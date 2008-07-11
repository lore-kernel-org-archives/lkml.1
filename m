Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbYGKSv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbYGKSv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 14:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbYGKSvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 14:51:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48197 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756446AbYGKSvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 14:51:48 -0400
Date: Fri, 11 Jul 2008 20:51:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [GIT PULL] dwarf headers integration
Message-ID: <20080711185133.GA17203@elte.hu>
References: <200807111546.m6BFkdqA026828@pobox-2.corp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807111546.m6BFkdqA026828@pobox-2.corp.redhat.com>
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


* Glauber Costa <gcosta@redhat.com> wrote:

> Ingo, please pull the latest master git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git 
>    master
> 
> into your tip/auto-x86-next tree
> 
> It contains integration of the dwarf headers.

thanks, applied. Note, for me to be able to pull it, please base the 
tree either against Linus's tree (if it can merge cleanly to 
tip/master), or base it against tip/x86/core.

auto-x86-next is a throwaway branch that gets regenerated, if i pulled 
from you i'd instantiate that throwaway merge commit as well in the 
'persistent' (append only) tip/x86/core as well.

So i cherry-picked out the commits from your tree.

	Ingo
