Return-Path: <linux-kernel-owner+w=401wt.eu-S1763036AbYEFAO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763036AbYEFAO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbYEFAOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:14:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36167
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753641AbYEFAOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:14:49 -0400
Date: Mon, 05 May 2008 17:14:49 -0700 (PDT)
Message-Id: <20080505.171449.38412201.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl
Subject: Re: [git pull] scheduler fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080505225823.GA24204@elte.hu>
References: <20080505225823.GA24204@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 6 May 2008 00:58:23 +0200

> 
> Linus, please pull the latest scheduler fixes git tree from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-fixes.git for-linus
> 
> this tree got booted up ~10 times on x86. Thanks,

Sanity booted and moderately tested on 64-cpu and 128-cpu Niagara2
systems.
