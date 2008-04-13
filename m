Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbYDMRGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbYDMRGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbYDMRGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:06:23 -0400
Received: from server117.advancednetworkhosting.com ([69.65.27.17]:43115 "EHLO
	server117.advancednetworkhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210AbYDMRGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:06:22 -0400
X-Greylist: delayed 3599 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Apr 2008 13:06:22 EDT
Message-ID: <48022F82.80704@eslashlonghorns.com>
Date: Sun, 13 Apr 2008 10:06:26 -0600
From: monte <monte@eslashlonghorns.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel bug
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Whitelisted: Yes
X-Assp-Envelope-From: monte@eslashlonghorns.com
X-Assp-Intended-For: linux-kernel@vger.kernel.org
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server117.advancednetworkhosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - eslashlonghorns.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I am new at this, this is the info you may need.

I am trying to using Ubuntu hardy (development branch), Kernel 
2.6.24-16, and get the following error

error 18: selected cylinder exceeds maximum supported by BIOS.

This started with kernel 2.6.24-15.  Currently I have to boot into 
kernel 2.6.24-14.

My BIOS are Award Modular Bios v4.51PC, with Award Plug and Play Bios 
ext v1.0A

Processor
300 MHz Intel Pentium II
32 kilobyte primary memory cache
512 Kilobyte secondary memory cache

Controllers
Standard Floppy Disk Controller
Intel 82371AB/EB PCI Bus Master IDE Controller
Primary IDE controller (dual fifo)
Secondary IDE controller (dual fifo)
Standard IDE/ESDI hard Disk Controller


Drives
38.10 Gig Usable Hard Drive Capacity

Main circuit Board
Board: i440LX-W977TF
Bus Clock:  66MHz

Memory Modules 192 Megabytes Installed Memory

Hope this is enough.
