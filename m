Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYEaWLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYEaWLJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 18:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYEaWK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 18:10:56 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:2272 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbYEaWKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 18:10:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vttc83bdftd7kbhGMaCAXtn1CMAodrTJv/KArlIj1NLU7olvUVs4hMcrQp55qtPUH3d3FVNrIsOTZuGxY/HT57hn1fG6Mgmxn/zQ7QpbWued6J0FvO0+XAKzh6l9ZTWBvjGqNzbLWmrnCu+WHp/Ave1Fznetb+R8DUS1vxzNvP4=
Message-ID: <dd18b0c30805311510i14c2d3ffi9b94e68d5b539677@mail.gmail.com>
Date: Sat, 31 May 2008 22:10:53 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [Bug #10825] appletouch after wakeup
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200805312325.31753.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
	 <200805312030.57213.oliver@neukum.org>
	 <dd18b0c30805311253q687bdc50j41f6c4fd93c5695c@mail.gmail.com>
	 <200805312325.31753.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 9:25 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Samstag, 31. Mai 2008 21:53:16 schrieb Justin Mattock:
>> On Sat, May 31, 2008 at 6:30 PM, Oliver Neukum <oliver@neukum.org> wrote:
>> > Am Samstag, 31. Mai 2008 19:48:06 schrieb Rafael J. Wysocki:
>> >> This message has been generated automatically as a part of a report
>> >> of recent regressions.
>> >>
>> >> The following bug entry is on the current list of known regressions
>> >> from 2.6.25.  Please verify if it still should be listed.
>> >
>> > AFAIK it is current and should be listed.
>> >
>> >        Regards
>> >                Oliver
>> >
>> >
>>
>> I agree, right now I upgraded to the latest git on thursday, and
>> performed a suspend to see if it would appear, but nothing.
>> I did notice the same error while doing a reboot, and noticed
>> appletouch was motionless until I removed and inserted the module back
>> in.
>> regards;
>>
>
> Can you please add your device to the quirk lis in drivers/usb/core/quirks.c
> with USB_QUIRK_RESET_RESUME and retest?
>
>        Regards
>                Oliver
>
>

Sure; I just need to figure out what the vendor ID.
regards;

-- 
Justin P. Mattock
