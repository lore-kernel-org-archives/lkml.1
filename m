Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbYHZIc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbYHZIc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbYHZIcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:32:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37514 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbYHZIcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:32:17 -0400
Date: Tue, 26 Aug 2008 10:32:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Diggs <kevdig@hypersurf.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Add kernel doc for the completion, fix
	kernel-doc-nano-HOWTO.txt
Message-ID: <20080826083202.GA24733@elte.hu>
References: <48B29696.3070808@hypersurf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B29696.3070808@hypersurf.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Diggs <kevdig@hypersurf.com> wrote:

> This patch adds kernel doc for the completion feature. It is in 
> kernel/sched.c and include/linux/completion.h.
>
> An error in the split-man.pl PERL snippet in kernel-doc-nano-HOWTO.txt 
> is also fixed.

applied to tip/sched/devel - thanks Kevin!

	Ingo
