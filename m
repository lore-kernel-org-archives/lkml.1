Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbZKTSWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbZKTSWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbZKTSWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:22:47 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:47675 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbZKTSWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:22:46 -0500
Date: Fri, 20 Nov 2009 19:22:49 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Stepping down as kbuild maintainer
Message-ID: <20091120182249.GA28251@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been fun to be kbuild maintainer but
as things stand right now I do not have the
time needed to be kbuild maintainer.

I have done this solely on a hobbyist basis
and family (3 kids etc) + job require me
so the kbuild maintainer job was becoming
a duty and not that fun suddenly.

Any linux related job required either
a move or too much working at home so
I drpped this idea.

So I decided to step down as maintainer
and I hope someone else can pick up.

What do I left "Orphan" as MAINTAINERS say?

I do not get many complains about kbuild these
days. All the basic stuff just works.

The only major complains are:
- no human can understand the kbuild files
  [Makefile, scripts/Makefile.*]
- select does not work (that kconfig btw)
- how to do strange this when building an external module

So I feel pretty confident that things does not blow
up on you when I leave.

I keep my mail address and will be reachable there.

Good luck!

	Sam

