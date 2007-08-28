Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbXH1OLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbXH1OLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 10:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbXH1OLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 10:11:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:44569 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752037AbXH1OLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 10:11:10 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18dq01PCwYdgzQegn5ej3HwuXBmH+pepYE7sz82hf
	VIPgw6InQvA7gF
Subject: Re: [git pull request] scheduler updates
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20070828113259.GA7922@elte.hu>
References: <20070828113259.GA7922@elte.hu>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 16:11:05 +0200
Message-Id: <1188310265.6336.5.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-28 at 13:32 +0200, Ingo Molnar wrote:
> Linus, please pull the latest scheduler git tree from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> 
> no big changes - 5 small fixes and 1 small cleanup:

FWIW, I spent a few hours testing these patches with various loads, and
all was peachy here.  No multimedia or interactivity aberrations noted.

	-Mike

