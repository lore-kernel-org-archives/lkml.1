Return-Path: <linux-kernel-owner+w=401wt.eu-S1759087AbYAFXwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087AbYAFXwX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 18:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbYAFXwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 18:52:15 -0500
Received: from rtr.ca ([76.10.145.34]:4091 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbYAFXwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 18:52:15 -0500
Message-ID: <478169AD.3020808@rtr.ca>
Date: Sun, 06 Jan 2008 18:52:13 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc7
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
..
> Both git trees and tar-balls/patches pushed out, should be mirroring out 
> within minutes. So there are no excuses to not try it out, and see if your 
> favorite regression has been fixed.
..

We're still missing the sata_qstor regression fix from Tejun,
and the patch from Venkatesh Pallipadi that reinstates max_cstate
in sysfs for !CPU_IDLE.

Cheers

