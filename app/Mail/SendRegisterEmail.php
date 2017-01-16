<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

class SendRegisterEmail extends Mailable
{
    use Queueable, SerializesModels;

     public $emailUser;

    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct($emailUser)
    {
        $this->emailUser = $emailUser;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return $this->view('email.verify')
                    ->subject('Verify your email address');
    }
}
