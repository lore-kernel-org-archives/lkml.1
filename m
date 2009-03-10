Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbZCJWA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbZCJWA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 18:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbZCJWAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 18:00:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32802 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533AbZCJWAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 18:00:14 -0400
Date: Tue, 10 Mar 2009 23:00:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip V2] x86: cpu architecture debug code
Message-ID: <20090310220009.GB30475@elte.hu>
References: <1236684201.3301.11.camel@localhost.localdomain> <20090310122806.GE5794@elte.hu> <1236697752.3387.2.camel@localhost.localdomain> <20090310152029.GN3850@elte.hu> <36674.1236714808@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36674.1236714808@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> On Tue, 10 Mar 2009 16:20:29 BST, Ingo Molnar said:
> 
> > If you look at arch/x86/mm/fault.c, they are sorted by length, 
> > and within the same length they are sorted alphabetically.
> 
> Huh? I just did a 'git pull' of Linus's tree, and I see fault.c looking like:

you should check the latest x86 tree instead:

 http://people.redhat.com/mingo/tip.git/README

	Ingo

