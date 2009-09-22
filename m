Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZIVOvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZIVOvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbZIVOvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:51:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42879 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402AbZIVOu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:50:59 -0400
Date: Tue, 22 Sep 2009 07:49:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] perf fixes
In-Reply-To: <20090922075144.GA21122@elte.hu>
Message-ID: <alpine.LFD.2.01.0909220749100.4950@localhost.localdomain>
References: <20090922075144.GA21122@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Sep 2009, Ingo Molnar wrote:
> 
> Please pull the latest perf-fixes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus
> 
> This fixes a brown paperbag build error in PowerPC caused by the rename.

Hmm. Forgot to push? I'm getting

	fatal: Couldn't find remote ref perf-fixes-for-linus

but maybe it's due to exta-long mirroring delays too.

		Linus
