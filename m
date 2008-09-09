Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYIIGGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYIIGGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 02:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYIIGG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 02:06:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33726 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbYIIGGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:06:25 -0400
Date: Tue, 9 Sep 2008 08:05:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Sanders <linux@sandersweb.net>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: Re: [git pull] x86 fixes
Message-ID: <20080909060548.GA8228@elte.hu>
References: <200809081932.m88JWVZG013061@askone.hos.anvin.org> <200809081634.24257.linux@sandersweb.net> <48C59C6F.2000408@zytor.com> <200809081816.50484.linux@sandersweb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809081816.50484.linux@sandersweb.net>
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


* David Sanders <linux@sandersweb.net> wrote:

> On Monday 08 September 2008 17:43, H. Peter Anvin wrote:
> > Does this patch fix that for you?
> >
> 
> Yes, thanks.

it fixes build errors in my test setup too.

	Ingo
