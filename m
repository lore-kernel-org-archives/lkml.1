Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbZFLQjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbZFLQjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZFLQi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:38:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbZFLQi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:38:56 -0400
Date: Fri, 12 Jun 2009 09:38:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] kmemcheck for mainline
In-Reply-To: <20090612132443.GA24002@damson.ad.medicalresearch.no>
Message-ID: <alpine.LFD.2.01.0906120933120.3237@localhost.localdomain>
References: <20090612132443.GA24002@damson.ad.medicalresearch.no>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Jun 2009, Vegard Nossum wrote:
> 
> Please consider pulling the kmemcheck tree;

No.

This seems to be 99% merges o fother branches.

I'm no longer pulling from people who can't keep their branches clean and 
develop without pulling from me every other day, or pulling from other 
random branches. If it gets that many conflicts, I just don't want to see 
it - there's something seriously wrong with it.

And if you just merge for some random reason, I don't want to pull it 
either. 

So in either case, I'm not pulling this. 

Just _look_ at that gitk thing. It has several stretches of just "Merge 
branch 'linus' into kmemcheck". WITH NO OTHER DEVELOPMENT IN BETWEEN!

This release, I'm only going to pull trees that don't do crazy shit.

			Linus
