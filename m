Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbYCaTV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbYCaTV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 15:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYCaTVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 15:21:49 -0400
Received: from rtr.ca ([76.10.145.34]:4271 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbYCaTVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 15:21:48 -0400
Message-ID: <47F139C9.50803@rtr.ca>
Date: Mon, 31 Mar 2008 15:21:45 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
Cc: Pavel Machek <pavel@suse.cz>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       jikos@suse.cz
Subject: Re: 2.6.25-rc7:  Ugh.
References: <47EBBD57.30902@rtr.ca> <47F11D8F.4020209@rtr.ca> <47F11FC6.8010701@rtr.ca> <200803312005.37804.oliver@neukum.org>
In-Reply-To: <200803312005.37804.oliver@neukum.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
>
> But if power is cut with newer kernels and older kernels retain it, something
> must have changed. Can you undo the ACPI changes since the last working
> kernel?
..

No, that's no different.
This notebook always cuts +5V from USB on suspend or poweroff.
Regardless of kernel version.  I don't know how common this is,
but all of my notebooks here have always behaved this way,
as have most (but not all) of the larger systems.

The two most recent PCIe motherboards I have here
do provide +5V standby power to USB, even when "OFF",
much to my annoyance and to the detriment of this planet.

Cheers
