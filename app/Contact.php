<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Contact extends Model
{
    protected $guarded = [];
    
    protected $dates = ["birthday"];
    
    public function setBirthdayAttributes($birthday)
    {
        $this->attributes['birthday'] = Carbon::parse($birthday);
    }
    
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
