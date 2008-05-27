Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbYE0Lru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbYE0Lru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 07:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbYE0Lrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 07:47:40 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:15700 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753587AbYE0Lrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 07:47:40 -0400
Subject: Re: [RFC: 2.6 patch] let GROUP_SCHED depend on BROKEN
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Adrian Bunk <bunk@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       vatsa <vatsa@in.ibm.com>
In-Reply-To: <20080527085830.GA20938@cs181133002.pp.htv.fi>
References: <20080527085830.GA20938@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Tue, 27 May 2008 13:47:29 +0200
Message-Id: <1211888849.12349.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-27 at 11:58 +0300, Adrian Bunk wrote: 

> I therefore suggest this patch to let GROUP_SCHED depend on BROKEN.

NAK - Most if not all issues have fixes or specific reverts already.

Your suggestion is really quite ridiculous and offensive to me. BROKEN
is for stuff that crashes kernels or corrupts user data. Group
scheduling does neither.

As I've said - and which you so 'tactfully' quoted - group scheduling is
a mathmatically complex topic that we are improving actively. The
feature is not enabled by default and it depends on EXPERIMENTAL.

Adrian - if you care about the subject so much - dive into the code and
help us, instead of becoming an obstacle. These past years you've shown
you're capable of understanding trivial C snippets, here is an
opportunity to show you can do real stuff too.

FYI your attitude in the past few weeks is getting on my nerves - you
act all self important but have not made a single contribution to the
kernel above the level of a janitor-newbie.

