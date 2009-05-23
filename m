Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZEWPxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZEWPxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 11:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZEWPw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 11:52:57 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:54515 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZEWPw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 11:52:57 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Sat, 23 May 2009 10:52:53 -0500
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <200905221946.01808.lkml@morethan.org> <4A1748A9.1020306@zytor.com>
In-Reply-To: <4A1748A9.1020306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905231052.56270.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri May 22 2009, H. Peter Anvin wrote:
> Michael S. Zick wrote:
> > Same integrated motherboard.
> 
> Which means same CPU, same BIOS, same motherboard (none of which you're
> telling us.)
> 
> cpuinfo and dmidecode would be informative.
>

Build: 
linux-2.6.30-rc6-ce1200v-09143_2.6.30-rc6-ce1200v-09143-22_i386.deb
The -09143lk later today.

Now also testing on the HP-2133 (C7-M/CN896) in addition
to the Everex Cloudbook/Sylvania gBook (C7-M/CX700).

Additional details:
http://forum.netbookuser.com/viewtopic.php?pid=6968#p6968

Download location:
http://hp-umpc.com/ce1200v/

HP-2133 data capture and the Sylvania/Everex data capture:
hp-2133-data_cap.tgz
sylvania-g-data.tar.gz

Summary:
On the ce1200v - first test 46 minutes uptime.
On the hp-2133 - ?? still running - no results yet. 
The -09143lk (yyddd) build not yet tested.

Mike

> 	-hpa
> 
