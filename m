Return-Path: <linux-kernel-owner+w=401wt.eu-S934069AbXFFRts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069AbXFFRts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756600AbXFFRt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:49:26 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33481 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbXFFRtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:49:25 -0400
Date: Wed, 6 Jun 2007 19:50:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Another version of cleanfile/cleanpatch (Re: [PATCH 08/19] scripts: Make cleanfile/cleanpatch warn about long lines)
Message-ID: <20070606175026.GA6303@uranus.ravnborg.org>
References: <20070603204700.GH9240@uranus.ravnborg.org> <20070605073335.GM7266@flower.upol.cz> <20070605081959.GB21991@uranus.ravnborg.org> <20070605133834.GO7266@flower.upol.cz> <20070605141254.GA24722@uranus.ravnborg.org> <20070605145759.GP7266@flower.upol.cz> <20070605151101.GQ7266@flower.upol.cz> <20070606174556.GS7266@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606174556.GS7266@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 07:45:56PM +0200, Oleg Verych wrote:
> While i'm against whitespace damaged files or patches since my very
> first patch, and don't like brain damaged programmer's tools called
> text editors, i also want to encourage UNIX-way of using userspace.
> 
> Of course, i might be wrong and foolish. Anyway, what i'm trying to do
> is not to become new generation of Visual Perl#(R) implemented in
> Java(R) using XML with userspace, that suck.
> 
> Many things in XXI century still can be done by tools founded 20-30
> years ago. Why not try to?

Because your shell script is unreadable by normal human beings[*]
while the perl script for people with a bit of perl fu can read it
and fix/modify it.

We want tools that can be maintained and enhanced by most people.

[*] Normal human beings are people with same level of shell
scripting/sed skills that I have just to put that straight.
	Sam
