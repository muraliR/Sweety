var setDatePickerOptions = function(params){

    var date = new Date();

    today_date = setFormattedDate(date);
    current_month_first_date = setFormattedDate(new Date(date.getFullYear(), date.getMonth(), 1));
    previous_month_first_date = setFormattedDate(new Date(date.getFullYear(),date.getMonth() - 1, 1));

    var clone_date =new Date(); // current date
    clone_date.setDate(1); // going to 1st of the month
    clone_date.setHours(-1);

    previous_month_last_date = setFormattedDate(new Date(clone_date.getFullYear(),clone_date.getMonth(),clone_date.getDate()));

    preselected_startdate = params['start_date'];
    preselected_enddate = params['end_date'];

    start_date = '';
    end_date = '';

    if(!isNaN(Date.parse(preselected_startdate)) && preselected_startdate.split("-").length == 3){
        splitted = preselected_startdate.split("-");
        y = splitted[0]; m = splitted[1]; d = splitted[2];
        if(!isNaN(Date.parse(new Date(y,m-1,d)))){
            start_date = setFormattedDate(new Date(y,m-1,d));
        }
    }


    if(!isNaN(Date.parse(preselected_enddate)) && preselected_enddate.split("-").length == 3){
        splitted = preselected_enddate.split("-");
        y = splitted[0]; m = splitted[1]; d = splitted[2];
        if(!isNaN(Date.parse(new Date(y,m-1,d)))){
            end_date = setFormattedDate(new Date(y,m-1,d));
        }
    }

    

    var ranges = {
        "Today": [
            today_date,
            today_date
        ],
        "This Month": [
            current_month_first_date,
            today_date
        ],
        "Last Month": [
            previous_month_first_date,
            previous_month_last_date,
        ]
    }

    var custom = {
        "start_date" : start_date,
        'end_date' : end_date
    }

    return {ranges : ranges, custom : custom};
}


var setFormattedDate = function(dateObj){
    return (dateObj.getMonth() + 1) +'/'+ (dateObj.getDate()) +'/'+ (dateObj.getFullYear());
}


$(document).ready(function(){

    var preselected_start_date = $('#start_date').val();
    var preselected_end_date = $('#end_date').val();

    var datepickerParams = { start_date : preselected_start_date, end_date : preselected_end_date };


    var dp_options = setDatePickerOptions(datepickerParams);
    var ranges = dp_options['ranges'];
    var custom_options = dp_options['custom'];

    $('#daterangepicker').daterangepicker({
        "ranges": ranges,
        "autoUpdateInput": false,
        "alwaysShowCalendars": true,
        "startDate": custom_options["start_date"],
        "endDate": custom_options["end_date"]
    }, function(start, end, label) {

        start_date = start.format('YYYY-MM-DD');
        end_date = end.format('YYYY-MM-DD');

        $('#start_date').val(start_date);
        $('#end_date').val(end_date);

        $('#daterangepicker').val(start_date + ' ' + end_date);
    });
});