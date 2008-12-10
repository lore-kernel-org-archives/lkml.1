Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbYLJU2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbYLJU2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 15:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756507AbYLJU15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 15:27:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:52497 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbYLJU14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 15:27:56 -0500
X-Greylist: delayed 2360 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Dec 2008 15:27:56 EST
Date: Wed, 10 Dec 2008 15:27:54 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       zippel@linux-m68k.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Better way to force a rebuild
In-Reply-To: <alpine.DEB.1.10.0812101524230.11805@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0812101526350.11805@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812101443550.11805@gandalf.stny.rr.com> <20081210200242.GA15692@uranus.ravnborg.org> <alpine.DEB.1.10.0812101524230.11805@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Dec 2008, Steven Rostedt wrote:

> > 
> > 	Sam
> > 
> 
> BTW, Sam, are you the new (or current) maintainer of kbuild/kconfig? If 
> so, then we need to update MAINTAINERS.  I just notice that you reply to 
> my kbuild questions more than anybody else (except for Andrew, but he 
> doesn't count ;-)

After writing this, I see...


KCONFIG
P:      Roman Zippel
M:      zippel@linux-m68k.org
L:      linux-kbuild@vger.kernel.org
S:      Maintained

[...]

KERNEL BUILD (kbuild: Makefile, scripts/Makefile.*)
P:      Sam Ravnborg
M:      sam@ravnborg.org
T:      git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-next.git
T:      git kernel.org:/pub/scm/linux/kernel/git/sam/kbuild-fixes.git
L:      linux-kbuild@vger.kernel.org
S:      Maintained


Bah, I need to make my vim search non-case-sensitive. My search for KBUILD 
came up with nothing, and then I searched for KCONFIG.

-- Steve


