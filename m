Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbZG0ByS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbZG0ByS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 21:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZG0ByR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 21:54:17 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:44066 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbZG0ByR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 21:54:17 -0400
Date: Mon, 27 Jul 2009 11:51:34 +1000
From: Anton Blanchard <anton@samba.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, mingo@elte.hu, paulus@samba.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/perf_counter: Add alignment-faults and
	emulation-faults sw events
Message-ID: <20090727015134.GA18301@kryten>
References: <20090706121845.GD4391@kryten> <1248659272.28464.29.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248659272.28464.29.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ben,

> BTW. The patch relies on some perctr changes I don't have in my tree
> (PERF_COUNT_SW_ALIGNMENT_FAULTS isn't defined for me)
> 
> Ingo, how do you want to handle that ? Should I wait til round 2 of the
> merge window before putting Anton's patch in or can I merge some of your
> stuff in powerpc-next as pre-reqs ? Or you can just take Anton's patch
> with my:
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> And stick it in your own queue (though pls, give me a pointer to the git
> tree in question so I can verify that I don't get new stuff that
> conflicts before we get to the merge window).

I've got another round of this series that I'll send out today.

Anton
