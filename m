Return-Path: <linux-kernel-owner+w=401wt.eu-S932842AbXBEOZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbXBEOZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932831AbXBEOZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:25:04 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:9114 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932815AbXBEOZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:25:00 -0500
Date: Mon, 05 Feb 2007 08:23:20 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: hdparm for lib_pata
In-reply-to: <8d158e1f0702050300s56dd1d9cg76e13b3a13f07de7@mail.gmail.com>
To: Patrick Ale <patrick.ale@gmail.com>
Cc: Stephen.Clark@seclark.us, linux-kernel@vger.kernel.org
Message-id: <45C73DD8.7070309@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.L/RjDlo6Njb5Jt7/9ENZuiASoV0@ifi.uio.no>
 <45C4DF2A.1070501@shaw.ca> <45C5178A.1000501@seclark.us>
 <8d158e1f0702031544h6c5f81c7s3c54a6192255d447@mail.gmail.com>
 <45C5249B.8020101@seclark.us>
 <8d158e1f0702031618w2249c64x18ad4d2f03ce3c69@mail.gmail.com>
 <8d158e1f0702050300s56dd1d9cg76e13b3a13f07de7@mail.gmail.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Ale wrote:
> Good morning all,
> 
> About the reason as of why it drops to PIO mode, I might have found
> the reason for this, I am just not sure if what i found is related.
> 
> When I opened my Athlon XP machine, took the cables out and replaced
> them for new cables, I found out that my southbridge fan wasnt
> spinning anymore, at all.
> 
> So my guess is that this chip is overheated at some point and starts
> causing problems.
> Now, it was always my comprehension that the southbridge does indeed
> control the ATA controller but only the onboard one, so even if the
> chip is having heat problems, my PCI add-on cards should still work on
> full UDMA100 speed, right?

The southbridge usually runs the PCI bus connected to the slots, so it's 
possible that PCI bus issues were causing problems..

> 
> I am re-assembling my athlon board again today, and as soon as I get
> the falling back to PIO mode errors again in dmesg I'll forward you
> the messages, like you asked :)
> 
> If someone could shine a light on my question about the southbridge,
> I'd really appriciate it, email me privately if you prefer.
> 
> Thanks!
> 
> Patrick
> 
