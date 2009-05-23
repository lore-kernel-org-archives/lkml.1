Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZEWUvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZEWUvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 16:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZEWUv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 16:51:26 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:44707 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZEWUv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 16:51:26 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Sat, 23 May 2009 15:51:22 -0500
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
Message-Id: <200905231551.25304.lkml@morethan.org>
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

HP-2133 (C7-M/CN896) - 09143 - No results - Still up - 6 hours.
A "personal best" for 2.6.30 on VIA hardware.

Cloudbook (C7-M/CX700) - 09143 - 45 minutes.
Cloudbook (C7-M/CX700) - 09143lk - Partial results - Still up - 4 hours.

Sometime recently, the echi (USB-2.0) driver went into its failure loop
but the kernel lived, and the music plays on (less the external mouse).
I think I will put it out of its misery now and take some time off myself.

Mike
> cpuinfo and dmidecode would be informative.
> 
> 	-hpa
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


