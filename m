Return-Path: <linux-kernel-owner+w=401wt.eu-S1760813AbYBFV1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813AbYBFV1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756498AbYBFV1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:27:36 -0500
Received: from crca.org.au ([67.207.131.56]:47622 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758359AbYBFV1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:27:35 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <47AA2627.4030509@nigel.suspend2.net>
Date: Thu, 07 Feb 2008 08:27:03 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Len Brown <len.brown@intel.com>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: [linux-pm] Re: Small pm documentation cleanups
References: <20080204234700.GA1912@elf.ucw.cz> <200802050224.51039.rjw@sisk.pl>	<47A7F581.8060300@nigel.suspend2.net> <20080205182712.GA9483@elf.ucw.cz>
In-Reply-To: <20080205182712.GA9483@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

Pavel Machek wrote:
> Hi!
> 
>>> On Tuesday, 5 of February 2008, Pavel Machek wrote:
>>>> Small documentation fixes/additions that accumulated in my tree.
>>>>
>>>> Signed-off-by: Pavel Machek <pavel@suse.cz>
>>> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
>>>
> ...
>>>> 0
>>>>   	acpi_sleep=	[HW,ACPI] Sleep options
>>>> -			Format: { s3_bios, s3_mode }
>>>> -			See Documentation/power/video.txt
>>>> +			Format: { s3_bios, s3_mode, s3_beep }
>>>> +			See Documentation/power/video.txt for s3_bios and s3_mode.
>>>> +			s3_beep is for debugging; it beeps on PC speaker as soon as
>>>> +			kernel's real-mode entry point is called.
>> s/kernel's/the kernel's/
> 
> Thanks for comments, I applied them.

You're welcome. Sorry for replying again, but I just noticed another one 
in the line above - it should be something like "it makes the PC's 
speaker beep as soon as" ('on PC speaker' isn't right).

Sorry for not getting that last time.

Nigel
