Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbYFIUwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbYFIUwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 16:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYFIUwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 16:52:24 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:37471 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbYFIUwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 16:52:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=H/0kYrNnITTrXsPN7MQsARfWyVwTXbwr3gjhZrrsjkjIbzrfKXP2vUxNvZ6nZCeBUs
         6cxyI0qK5X3vJ45iDoPsWaAIqpwh/FyZfXC2PA/8ETmsa5HxQjnVTdzTP3CQNJwGUCW3
         rJqzd/WPHVdbs7J3KkTGnyeWxvjMX0+/KL1/s=
Message-ID: <dd18b0c30806091352g390b1e5dj11118bce07942ef6@mail.gmail.com>
Date: Mon, 9 Jun 2008 20:52:21 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [Bug #10825] appletouch after wakeup
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200806092231.32190.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
	 <200806092153.09686.oliver@neukum.org>
	 <dd18b0c30806091329q7152553fx2a5beb6013b33a44@mail.gmail.com>
	 <200806092231.32190.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2008 at 8:31 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Montag 09 Juni 2008 22:29:05 schrieb Justin Mattock:
>> On Mon, Jun 9, 2008 at 7:53 PM, Oliver Neukum <oliver@neukum.org> wrote:
>> > Am Montag 09 Juni 2008 18:18:19 schrieb Justin Mattock:
>
>> >> Cool; just an update, I've suspended the system numerous times it
>> >> seems appletouch is behaving correctly, in fact
>> >> I think better, why: when I start the system I have two finger scroll
>> >> functionality, then when suspending the system
>> >> after waking up the two finger scroll is still functional.
>> >> regards;
>> >>
>> >
>> > With last week's patch or today's patch?
>> >
>> >        Regards
>> >                Oliver
>> >
>> >
>>
>> Last weeks patch.
>> regards;
>>
>
> Could you also try today's patch?
>
>        Regards
>                Oliver
>
>

Sure, where is it located.
regards;

-- 
Justin P. Mattock
