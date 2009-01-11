Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZAKUaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZAKUaA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 15:30:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbZAKU3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 15:29:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35672 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZAKU3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 15:29:48 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Johannes Schindelin <Johannes.Schindelin@gmx.de>, git@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: current git kernel has strange problems during bisect
From: Andi Kleen <andi@firstfloor.org>
References: <200901111602.53082.borntraeger@de.ibm.com>
	<200901111607.59054.borntraeger@de.ibm.com>
	<alpine.DEB.1.00.0901111613250.3586@pacific.mpi-cbg.de>
	<200901111620.03345.borntraeger@de.ibm.com>
	<alpine.LFD.2.00.0901111113150.6528@localhost.localdomain>
Date: Sun, 11 Jan 2009 21:29:20 +0100
In-Reply-To: <alpine.LFD.2.00.0901111113150.6528@localhost.localdomain> (Linus Torvalds's message of "Sun, 11 Jan 2009 11:13:30 -0800 (PST)")
Message-ID: <87tz85fuxr.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> For bisect purposes, if you know you're not chasing down a btrfs issue, 
> you can do
>
> 	git bisect good 34353029534a08e41cfb8be647d734b9ce9ebff8

Could you perhaps add some standard tag for that commit? That 
would make it easier than to always find the exact btrfs commit.

Just an idea.

-Andi

-- 
ak@linux.intel.com
