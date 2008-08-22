Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbYHVGCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbYHVGCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYHVGC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:02:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33619 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbYHVGCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:02:25 -0400
Date: Fri, 22 Aug 2008 08:02:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alok Kataria <akataria@vmware.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Zachary Amsden <zach@vmware.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86: Fix VMI for early params...for mainline
Message-ID: <20080822060215.GF14110@elte.hu>
References: <1219343546.18349.45.camel@alok-dev1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219343546.18349.45.camel@alok-dev1>
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


* Alok Kataria <akataria@vmware.com> wrote:

> While fixing a recent breakage in VMI on the recent x86 tree, I 
> noticed that vmi specific kernel commandline parameters were broken. 
> Below is the fix.

applied to tip/x86/urgent, thanks Alok.

	Ingo
