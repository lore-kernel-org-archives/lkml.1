Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbYAGLSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbYAGLSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbYAGLRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:17:55 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:61344 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755210AbYAGLRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:17:54 -0500
Date: Mon, 7 Jan 2008 11:17:51 +0000
From: Ben Dooks <ben@fluff.org>
To: cksim <cksim@singnet.com.sg>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Size of kernel halts startup
Message-ID: <20080107111751.GA16087@fluff.org.uk>
References: <1199676509.47819c5deaf60@discus.singnet.com.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199676509.47819c5deaf60@discus.singnet.com.sg>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 11:28:29AM +0800, cksim wrote:
> Hi,
> 
> Yesterday, I have encountered an issue when the kernel size is more than 1.3MB.
> 
> Info on problem encountered as follows:
> 1) I am using Atmel AT91SAM9261 part. Circuit similar to that of AT91SAM9261EK
> evaluation board.
> 
> 2) I am booting the kernel through NFS. Bootloader
> used is UBoot 1.1.5. Kernel used is 2.6.23.1
> 
> 3) For the past weeks, the kernel size was about 1.3MB and kernel bootup over NFS was fine.
> 
> 4) Yesterday, I have done a menuconfig and turned on some drivers (USB HID and I2C).  This resulted in a kernel size of about 1.4MB.
> 
> 5) Booting up this 1.4MB kernel over NFS causes a register dump to appear and the system is halted.
> 
> Is this issue related to the size of the kernel or it is due to some conflict in memory ?
> 
> If it is related to size of kernel, how can the size be increased so as to resolve this issue ?
> 
> Appreciate any help and advises.
> 
> Thanks in advance.
> 
> Sim CK

You're best of subscribing to linux-arm-kernel list and asking there
as you'll be more likely to find people who are actually using these
sorts of systems.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
