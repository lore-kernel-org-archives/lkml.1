Return-Path: <linux-kernel-owner+w=401wt.eu-S2993097AbXCIJ5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993097AbXCIJ5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 04:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993096AbXCIJ5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 04:57:32 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:43004 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993097AbXCIJ5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 04:57:32 -0500
X-Originating-Ip: 74.109.98.130
Date: Fri, 9 Mar 2007 04:53:58 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: any thoughts yet on a "generic" ioctl.h?
In-Reply-To: <45F0D798.4050602@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0703090450160.30726@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703081556260.9349@CPE00045a9c397f-CM001225dbafb6>
 <45F0D798.4050602@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Stefan Richter wrote:

> Robert P. J. Day wrote:
> >   i asked about this a while back, but i still haven't heard a
> > definitive response as to whether it's acceptable.
>
> Maybe you get response if you post a complete patch.

that *was* the complete patch -- its purpose was simply to make
asm-generic/ioctl.h general enough to allow arch-specific ioctl.h
files to *subsequently* be simplified.  there was no need to do
*everything* in one step -- each simplification could be submitted as
a separate arch-specific patch, as many things are.

i was more asking about the *philosophy* of that patch, and whether
there were any obvious objections.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
