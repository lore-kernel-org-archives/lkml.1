Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbYLJUi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbYLJUi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 15:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbYLJUiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 15:38:19 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:48808 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbYLJUiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 15:38:18 -0500
Date: Wed, 10 Dec 2008 21:39:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       zippel@linux-m68k.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Better way to force a rebuild
Message-ID: <20081210203945.GB16674@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0812101443550.11805@gandalf.stny.rr.com> <20081210200242.GA15692@uranus.ravnborg.org> <alpine.DEB.1.10.0812101524230.11805@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812101524230.11805@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 03:26:14PM -0500, Steven Rostedt wrote:
> > 
> > 	Sam
> > 
> 
> BTW, Sam, are you the new (or current) maintainer of kbuild/kconfig? If 
> so, then we need to update MAINTAINERS.  I just notice that you reply to 
> my kbuild questions more than anybody else (except for Andrew, but he 
> doesn't count ;-)

>From MAINTAINERS:
KERNEL BUILD (kbuild: Makefile, scripts/Makefile.*)
P:      Sam Ravnborg
M:      sam@ravnborg.org
T:      git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-next.git
T:      git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
L:      linux-kbuild@vger.kernel.org
S:      Maintained


Roman Zippel is the maintainer of kconfig and we pass the
patches via me.
Again from MAINTAINERS:
KCONFIG
P:      Roman Zippel
M:      zippel@linux-m68k.org
L:      linux-kbuild@vger.kernel.org
S:      Maintained

	Sam
