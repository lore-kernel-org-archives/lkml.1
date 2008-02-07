Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYBGG33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYBGG33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbYBGG3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:29:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:42709 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYBGG3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:29:19 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: nigel@nigel.suspend2.net
Subject: Re: [linux-pm] Re: Small pm documentation cleanups
Date: Thu, 7 Feb 2008 01:28:34 -0500
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
References: <20080204234700.GA1912@elf.ucw.cz> <20080205182712.GA9483@elf.ucw.cz> <47AA2627.4030509@nigel.suspend2.net>
In-Reply-To: <47AA2627.4030509@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802070128.34838.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied
(with nigel's last comment included)

thanks,
-len

On Wednesday 06 February 2008 16:27, Nigel Cunningham wrote:
> Hi again.
> 
> Pavel Machek wrote:
> > Hi!
> > 
> >>> On Tuesday, 5 of February 2008, Pavel Machek wrote:
> >>>> Small documentation fixes/additions that accumulated in my tree.
> >>>>
> >>>> Signed-off-by: Pavel Machek <pavel@suse.cz>
> >>> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> >>>
> > ...
> >>>> 0
> >>>>   	acpi_sleep=	[HW,ACPI] Sleep options
> >>>> -			Format: { s3_bios, s3_mode }
> >>>> -			See Documentation/power/video.txt
> >>>> +			Format: { s3_bios, s3_mode, s3_beep }
> >>>> +			See Documentation/power/video.txt for s3_bios and s3_mode.
> >>>> +			s3_beep is for debugging; it beeps on PC speaker as soon as
> >>>> +			kernel's real-mode entry point is called.
> >> s/kernel's/the kernel's/
> > 
> > Thanks for comments, I applied them.
> 
> You're welcome. Sorry for replying again, but I just noticed another one 
> in the line above - it should be something like "it makes the PC's 
> speaker beep as soon as" ('on PC speaker' isn't right).
> 
> Sorry for not getting that last time.
> 
> Nigel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
