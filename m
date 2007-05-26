Return-Path: <linux-kernel-owner+w=401wt.eu-S1762914AbXEZQVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762914AbXEZQVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758290AbXEZQVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:21:04 -0400
Received: from mail.tmr.com ([64.65.253.246]:47750 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbXEZQVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:21:02 -0400
Message-ID: <46585F02.6060806@tmr.com>
Date: Sat, 26 May 2007 12:23:30 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21.1 on Fedora Core 6 breaks LVM/vgscan
References: <200705210632.l4L6Wkt0004225@turbo.physics.adelaide.edu.au>
In-Reply-To: <200705210632.l4L6Wkt0004225@turbo.physics.adelaide.edu.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Woithe wrote:
> On 21 May 2007 I wrote:
> 
>> Attempting to compile a 2.6.21.1 kernel for use on a Fedora Core 6 box
>> results in a panic at boot because the root filesystem can't be found.
> 
> I have just compiled 2.6.22-rc2 with the configuration file given in my
> previous post and the resulting kernel successfully boots on the machine
> concerned.  Whatever broke LVM for this machine in between 2.6.18 and
> 2.6.21.1 has now been fixed.
> 
I haven't had any problem booting with any of the kernels, but when I 
try to build a kernel with a Fedora config from /boot, it builds fine 
but doesn't boot after install. I started by building a very basic 
kernel for testing, and then started adding features to get everything I 
need. But just using the latest FC6 config file gets me a kernel which 
fails in just the way you mention.

> There is still a problem with the CDROM but I will follow up in another
> thread about that.
> 
Happy to say I don't see that, I'm using PATA optical devices, and USB 
on some machines, both work. I can't get scanning to work even after 
buying a "supported" scanner, so I may have to go back to Slackware and 
a 2.4 kernel on one machine, but boot and run does fine.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
