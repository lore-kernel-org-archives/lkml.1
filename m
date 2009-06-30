Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbZF3XY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbZF3XY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbZF3XYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:24:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55097 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbZF3XYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:24:19 -0400
Date: Wed, 1 Jul 2009 01:23:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][ PATCH] kprobes: fix kprobe selftest configuration
	dependency
Message-ID: <20090630232359.GH17968@elte.hu>
References: <20090622210302.4984.82798.stgit@localhost.localdomain> <20090630143806.9ab4519d.akpm@linux-foundation.org> <alpine.LFD.2.01.0906301440280.3605@localhost.localdomain> <4A4A8D91.8040009@redhat.com> <4A4A9D89.3090600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4A9D89.3090600@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0571]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Oops, I couldn't reproduce this bug on the latest -tip tree.

maybe because i applied your fix already? ;-)

	Ingo
