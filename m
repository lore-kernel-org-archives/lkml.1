Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbZFLPus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbZFLPus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZFLPuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:50:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37349 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbZFLPuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:50:40 -0400
Date: Fri, 12 Jun 2009 17:50:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open
	when supported
Message-ID: <20090612155038.GA26644@elte.hu>
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org> <20090612120507.GH16044@elte.hu> <8bd0f97a0906120816w26d91530nf1e1967470beb99c@mail.gmail.com> <20090612152134.GA23483@elte.hu> <8bd0f97a0906120829p628751e9gb557f6a14e98fae2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0906120829p628751e9gb557f6a14e98fae2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Frysinger <vapier.adi@gmail.com> wrote:

> i cant find anything in Documentation/ covering perf counters.  
> did i miss some file ?

it's in tools/perf/design.txt.

	Ingo
