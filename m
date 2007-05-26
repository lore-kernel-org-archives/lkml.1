Return-Path: <linux-kernel-owner+w=401wt.eu-S1763420AbXEZQX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763420AbXEZQX6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758479AbXEZQXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:23:52 -0400
Received: from mail.tmr.com ([64.65.253.246]:47753 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbXEZQXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:23:51 -0400
Message-ID: <46585FAC.80208@tmr.com>
Date: Sat, 26 May 2007 12:26:20 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
References: <200705210657.l4L6vKRT005158@turbo.physics.adelaide.edu.au>
In-Reply-To: <200705210657.l4L6vKRT005158@turbo.physics.adelaide.edu.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Woithe wrote:
> A collegue of mine has an Intel mainboard with the i865 chipset onboard
> (DQ965).  All kernels up to and including 2.6.22-rc2 do not detect the IDE
> CDROM/DVDROM when booting.  The SATA hard drive is found without any
> problems.
> 
Let me belatedly ask if the device shows up in POST at cold boot. It may 
need some BIOS setting to be visible.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
