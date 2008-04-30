Return-Path: <linux-kernel-owner+w=401wt.eu-S1760900AbYD3IVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900AbYD3IVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 04:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbYD3IVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 04:21:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46654 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbYD3IVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:21:17 -0400
Date: Wed, 30 Apr 2008 10:20:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Avi Kivity <avi@qumranet.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Carsten Otte <cotte@de.ibm.com>
Subject: Re: small author mixup  (was: git pull KVM updates for 2.6.26rc)
Message-ID: <20080430082032.GA23528@elte.hu>
References: <1209310768-12322-1-git-send-email-avi@qumranet.com> <200804301012.05179.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804301012.05179.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> While it is not a typical case, is there a better way of specifying 
> multiple authors to avoid future confusion?

i think the established rule is that there's one Author field per 
commit. Multiple authors should either submit a tree with multiple 
commits (which shows the exact lineage of work) - or, for nontrivial 
joint work where the development tree would be way too messy, expose 
proper credits in copyrights/credit info in the source code. It's seldom 
that work is split exactly in half - better spell out who did what both 
in the source code and in the commit log - without trying to formalize 
the From/Author line. [which line will always be imprecise for multiple 
authors.]

	Ingo
