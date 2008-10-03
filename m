Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYJCRcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYJCRcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYJCRcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:32:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45639 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbYJCRcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:32:05 -0400
Date: Fri, 3 Oct 2008 19:31:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Markers synchronize unregister static inline
Message-ID: <20081003173144.GC15583@elte.hu>
References: <48E08B05.7030802@cn.fujitsu.com> <20080929082722.GB18663@elte.hu> <20080929150513.GC11245@Krystal> <20081002235650.43ca075c.akpm@linux-foundation.org> <20081003155254.GB1607@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003155254.GB1607@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0304]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Turn marker synchronize unregister into a static inline. There is no reason to
> keep it as a macro over a static inline.
> 
> Ingo, can you pull this into -tip on top of the previous "Markers
> synchronize unregister" patch ?

applied to tip/tracing/markers, thanks Mathieu!

	Ingo
