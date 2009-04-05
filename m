Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbZDETBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbZDETBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 15:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZDETAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 15:00:46 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:51008 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbZDETAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 15:00:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oo6TBYBBAQnzEKwFdA57adqJc3viB2XOvN7rqcEbRi+1wVQR2VlvMw+0rjmqo22bpa
         hK0hCkg00bg1ROX+Qdbscpvw0wuDugKzDB+e0aNmVoONuLLQLm9a+HSOA4CMO+uTaMPX
         d2WpRvpuG1lUOwKbqcz7GBSiFt+2F//ERldOQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904052046030.747@localhost.localdomain>
References: <3efb10970904030502q1068731fl5b92f93d5341b43e@mail.gmail.com>
	 <alpine.LFD.2.00.0904051257470.747@localhost.localdomain>
	 <3efb10970904051139ue3802b1ib33487418188e4bc@mail.gmail.com>
	 <alpine.LFD.2.00.0904052046030.747@localhost.localdomain>
Date: Sun, 5 Apr 2009 21:00:39 +0200
X-Google-Sender-Auth: 7e4481fecf44a824
Message-ID: <3efb10970904051200g4c725badp6d05092b70dd56a2@mail.gmail.com>
Subject: Re: System deadlock on 2.6.24-rt20 (-rt27 panics on 
	locking-api-selftests)
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

2009/4/5 Thomas Gleixner <tglx@linutronix.de>:
> On Sun, 5 Apr 2009, Remy Bohmer wrote:
>> > What happens if you disable the self tests ?
>>
>> The system boots and seems to run properly. We did not yet test for a
>> longer period of time, but the first looks are that the hangups we had
>> are gone now. But it would be good for the peace of mind if the
>> locking-selftest was working properly.
>
> Patches are welcome. :)
>
> Seriously, I'm not going to look into that as my limited capacity is
> focussed on 2.6.29-rt.

As it should be... :-)
I was not asking you to fix it, my apologies if you read it that way.
It is not that important to me, just a nice-to-have.


Kind Regards,

Remy
