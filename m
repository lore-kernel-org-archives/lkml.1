Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXB1MV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXB1MV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 07:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932183AbXB1MV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 07:21:29 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:53238 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbXB1MV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 07:21:28 -0500
Message-ID: <45E5737D.9070205@gmail.com>
Date: Wed, 28 Feb 2007 13:20:13 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: Bill Davidsen <davidsen@tmr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Stephane Eranian <eranian@hpl.hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot
   be mounted without hanging up the whole system
References: <20070226180635.GA644@tv-sign.ru>	<Pine.LNX.4.64.0702261006440.12485@woody.linux-foundation.org>	<45E3493C.1040706@gmail.com>	<Pine.LNX.4.64.0702261308490.12485@woody.linux-foundation.org>	<45E4EC08.50409@tmr.com> <20070228130430.78933e67@lxorguk.ukuu.org.uk>
In-Reply-To: <20070228130430.78933e67@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2007 02:04 PM, Alan wrote:

> PLIP/Laplink runs bidirectional on ordinary parallel ports. The 
> bidirectional part of parallel ports in "normal" modes is still used
> for things like PnP detection of printer and drivers.

And my parallel port Iomega ZIP drive, it seems. I actually checked 
earlier and although it doesn't use DMA (it says it's using "EPP 
32-bit") it does use bidrectional communication; it's an sd device.

I admit most of those will be confined to history as well with respect 
to actual use (they existed with 100MB, 250 and 750MB disks, although 
the 750 one probably not as parallel) but they looked cool, so people 
haven't just thrown them away yet :)

Rene
