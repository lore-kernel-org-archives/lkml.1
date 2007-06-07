Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbXFGHA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbXFGHA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbXFGHAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:00:20 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:46623 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbXFGHAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:00:17 -0400
Date: Thu, 7 Jun 2007 08:58:40 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Tom Moore <tmoore@spatial.ca>, linux-kernel@vger.kernel.org
Subject: Re: 4Gb ram not showing up
In-Reply-To: <a781481a0706061418m7f51dc1bke079e6e6b7d5f930@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0706070857500.1547@yvahk01.tjqt.qr>
References: <46642C60.209@spatial.ca>  <20070604191052.GD10008@csclub.uwaterloo.ca>
  <46646B4C.2070707@spatial.ca>  <20070605185721.GW10006@csclub.uwaterloo.ca>
 <a781481a0706061418m7f51dc1bke079e6e6b7d5f930@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 7 2007 02:48, Satyam Sharma wrote:
> On 6/6/07, Lennart Sorensen <lsorense@csclub.uwaterloo.ca> wrote:
>> [...]
>> A better description would be:
>> 
>> "Select this if you have a 32-bit processor and memory mapped in the 1GB
>> to 4GB address range."
>> [...]
>> That one would be better as:
>> 
>> "Select this if you have a 32-bit processor and ram mapped in the address
>> range above 4GB."
>
> Ugh, no! How can we expect the user compiling a kernel to be *so*
> familiar with address space re-mapping / BIOSen (_his_ particular
> BIOS, specifically, and what / how it re-maps memory) / etc to be
> able to answer such questions? "Select ... if you have ... RAM
> installed" is perfectly clear, simple, and all that's needed.

Then explain it.

"Select this if you have a 32 bit cpu and ram mapped above 4 G.
To see where RAM is mapped, interpret the E820 lines from dmesg,
for more information see Documentation/e820.txt"

or something like that.


	Jan
-- 
