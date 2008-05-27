Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbYE0L2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbYE0L2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 07:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbYE0L2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 07:28:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:43917 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756879AbYE0L2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 07:28:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+WVCNHakiWjBvi+2vw3Y5pxemqhkb4k0OMRwipDM
	SUqW4qhC7HbRH6
Subject: Re: [RFC: 2.6 patch] let GROUP_SCHED depend on BROKEN
From: Mike Galbraith <efault@gmx.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080527102654.GB20938@cs181133002.pp.htv.fi>
References: <20080527085830.GA20938@cs181133002.pp.htv.fi>
	 <1211881658.6742.20.camel@marge.simson.net>
	 <20080527102654.GB20938@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Tue, 27 May 2008 13:27:58 +0200
Message-Id: <1211887678.4834.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-27 at 13:26 +0300, Adrian Bunk wrote:

> - the EXPERIMENTAL dependencies in many areas of the kernel are so
>   out of sync with the actual code quality that the presence or absence
>   of such a dependency isn't a clear indication of the current status

Then the thing to do is fix _that_, not move group scheduling.

	-Mike

