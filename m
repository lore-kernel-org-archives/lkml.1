Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbYIIUt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbYIIUt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYIIUtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:49:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54001 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbYIIUtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:49:18 -0400
Date: Tue, 9 Sep 2008 22:49:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Sanders <linux@sandersweb.net>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080909204901.GA27671@elte.hu>
References: <200809081932.m88JWVZG013061@askone.hos.anvin.org> <200809091518.16311.linux@sandersweb.net> <alpine.LFD.1.10.0809091255420.3117@nehalem.linux-foundation.org> <200809091637.32650.linux@sandersweb.net> <alpine.LFD.1.10.0809091345100.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809091345530.3117@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809091345530.3117@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 9 Sep 2008, Linus Torvalds wrote:
> > 
> > Maybe it hadn't finished mirroring out?
> 
> oops. Or maybe I had forgotten to push it out.
> 
> 		Linus "_now_ I did" Torvalds

that did the trick - commit 14469a8 is visible now here :)

	Ingo
