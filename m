Return-Path: <linux-kernel-owner+w=401wt.eu-S934987AbXFFTCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934987AbXFFTCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763284AbXFFTCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:02:41 -0400
Received: from raven.upol.cz ([158.194.120.4]:63846 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761375AbXFFTCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:02:40 -0400
Date: Wed, 6 Jun 2007 21:14:26 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Another version of cleanfile/cleanpatch
Message-ID: <20070606191426.GT7266@flower.upol.cz>
References: <20070603204700.GH9240@uranus.ravnborg.org> <20070605073335.GM7266@flower.upol.cz> <20070605081959.GB21991@uranus.ravnborg.org> <20070605133834.GO7266@flower.upol.cz> <20070605141254.GA24722@uranus.ravnborg.org> <20070605145759.GP7266@flower.upol.cz> <20070605151101.GQ7266@flower.upol.cz> <20070606174556.GS7266@flower.upol.cz> <20070606175026.GA6303@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606175026.GA6303@uranus.ravnborg.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 07:50:26PM +0200, Sam Ravnborg wrote:
[]
> > Many things in XXI century still can be done by tools founded 20-30
> > years ago. Why not try to?
> 
> Because your shell script is unreadable by normal human beings[*]
> while the perl script for people with a bit of perl fu can read it
> and fix/modify it.
> 
> We want tools that can be maintained and enhanced by most people.
> 
> [*] Normal human beings are people with same level of shell
> scripting/sed skills that I have just to put that straight.

In many cases i think, it's limiting one's imagination and expanding
laziness[0].

In the school algebra (usually) there are many exercises with
plain-useless equations and formulas you must solve or simplify.
Guess why? Thus my proposition. ;)

---
[0] Now, when most UNIX tools done with good quality (courtesy of the
    GNU project), it's time not to convert programmer's laziness[1] to
    ordinary one. Why there's one big and slow Bourne again shell, yet
    to have fast ([d]ash) and tiny one took more time? As result more
    efforts to remove bashizms...

[1] Ironically connected to Perl chapter of UNIX Power Tools
    <http://unix.org.ua/orelly/unix/upt/ch37_02.htm>
____
