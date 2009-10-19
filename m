Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZJSHZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZJSHZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZJSHZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:25:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41542 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbZJSHZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:25:23 -0400
Date: Mon, 19 Oct 2009 09:25:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anton Blanchard <anton@samba.org>
Cc: benh@kernel.crashing.org, paulus@samba.org, a.p.zijlstra@chello.nl,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] powerpc perf_event: Add alignment-faults and
	emulation-faults software events
Message-ID: <20091019072517.GB17960@elte.hu>
References: <20091018110929.GK4808@kryten> <20091018111126.GL4808@kryten> <20091018111300.GM4808@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091018111300.GM4808@kryten>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anton Blanchard <anton@samba.org> wrote:

> Hook up the alignment-faults and emulation-faults events for powerpc.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

nice.

The first patch is for perf events - it would be nice if we could do the 
two PowerPC changes via the perf events tree - that would speed up the 
upstream availability of this new feature. Ben, what do you think?

	Ingo
