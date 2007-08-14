Return-Path: <linux-kernel-owner+w=401wt.eu-S932652AbXHNS2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652AbXHNS2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758335AbXHNS2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:28:14 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4782 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756981AbXHNS2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:28:12 -0400
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch
	-	scripts/get_maintainer.pl
From: Joe Perches <joe@perches.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: git@vger.kernel.org, Junio C Hamano <gitster@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <46C1EE6F.2080807@gmail.com>
References: <1186984174.10249.7.camel@localhost>
	 <200708131933.10125.m.kozlowski@tuxland.pl>
	 <1187026955.2688.4.camel@laptopd505.fenrus.org>
	 <1187037445.6628.98.camel@heimdal.trondhjem.org>
	 <1187054366.2757.0.camel@laptopd505.fenrus.org>
	 <46C10AA8.3090505@gmail.com> <20070814102033.604c8695@the-village.bc.nu>
	 <46C1CFFE.4000001@gmail.com> <1187110824.32555.76.camel@localhost>
	 <46C1EE6F.2080807@gmail.com>
Content-Type: text/plain
Date: Tue, 14 Aug 2007 11:28:02 -0700
Message-Id: <1187116082.32555.122.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 20:03 +0200, Rene Herman wrote:
> "git info --maintainer drivers/ide/ide-cd.c" or some such would say "Alan 
> Cox <alan@...>".

Perhaps maintainer(s), approver(s), listener(s)?

I think something like this should be a git-goal.
What do the git-wranglers think?

Until a time in the future when a system like that exists,
I suggest keeping MAINTAINERS up-to-date with

F:	pattern

It'll be useful as git-set-maintainer seeds at least.

> sticking  headers on every source file isn't nice anyway --
> it's meta-information and the SCM can maintain it.

It's like looking at $CVS$ keywords.  Unsightly.

cheers,  Joe

