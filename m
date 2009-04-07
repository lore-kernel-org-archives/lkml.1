Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZDGHtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZDGHtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZDGHt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:49:28 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46649 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbZDGHt0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:49:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vqY+b5qvVaQK6lP63F9lKLpxivOngm2V6cQThlv9+9n4D2+rKdzrm/XaSYFX1dYNDf
         BfSDRoirTv6K4KCcYMPh9m8Kr/8dyNwvhSc5F+oq6tR4SvAbxoGM8HkL9wdPvvmi7NJ9
         vijkmBv81dR9YxXZPNGWJiP3/wEg77loPASuI=
MIME-Version: 1.0
In-Reply-To: <1239088491.19390.25.camel@violet>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
	 <AsKNxFx2juN.A.bxC.BJn2JB@chimera> <1239088491.19390.25.camel@violet>
Date: Tue, 7 Apr 2009 09:49:23 +0200
Message-ID: <8db1092f0904070049o675de150qd319fc5853ec9bd8@mail.gmail.com>
Subject: Re: [Bug #12499] Problem with using bluetooth adaper connected to usb 
	port
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/7 Marcel Holtmann <marcel@holtmann.org>:
> Hi Rafael,
>
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.28.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=12499
>> Subject               : Problem with using bluetooth adaper connected to usb port
>> Submitter     : "Maciej Rutecki" <maciej.rutecki@gmail.com>
>> Date          : 2009-01-13 18:34 (84 days old)

I forgot this bug :)

>> References    : http://marc.info/?l=linux-kernel&m=123187185426236&w=4
>
> I prefer to have this checked against 2.6.30-rc1 once Linus released
> that one. I think that I know the root cause for this one and it is
> actually a hardware/firmware bug. Some Bluetooth dongles expect to have
> the interrupt and bulk URBs available at the same time. Otherwise they
> do pee in their pants.

I will check -rc1 when will be available.

>
> Regards
>
> Marcel
>
>
>


Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
