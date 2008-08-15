Return-Path: <linux-kernel-owner+w=401wt.eu-S1759600AbYHOQv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600AbYHOQv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYHOQvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:51:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59494 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbYHOQvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:51:48 -0400
Date: Fri, 15 Aug 2008 18:51:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [GIT PULL] new shot at time.c integration
Message-ID: <20080815165134.GB29956@elte.hu>
References: <200808151625.m7FGP3Gn027609@int-mx1.corp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808151625.m7FGP3Gn027609@int-mx1.corp.redhat.com>
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
>    git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git master
> 
> into your tree
> 
> It is based on your tip/master branch.

thanks, i've pulled it and rebased it to -git - as that's the best base 
this early in the cycle. I've pushed out the result into tip/x86/time - 
havent integrated it into tip/master yet.

	Ingo
