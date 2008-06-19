Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbYFSVg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbYFSVg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbYFSVcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:32:43 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:51893 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598AbYFSVcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:32:42 -0400
Subject: Re: [git pull] x86 fixes
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Patrick McHardy <kaber@trash.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
In-Reply-To: <20080619151333.GA8952@elte.hu>
References: <20080619151333.GA8952@elte.hu>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 19 Jun 2008 23:29:46 +0200
Message-Id: <1213910986.21443.42.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tor, 19 06 2008 kl. 17:13 +0200, skrev Ingo Molnar:
> Linus,
> 
> please pull the latest x86 fixes git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus
> 

> Suresh Siddha (1):
>       x86: fix NULL pointer deref in __switch_to

Ingo, Rusty and Suresh

This doesn't contain the lguest part of the fix that Patrick and I
reported were necessary to fix the problem we reported. Is this being
pushed via another path?


Simon Holm Th﻿øgersen

