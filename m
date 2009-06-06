Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbZFFIle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbZFFIle (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 04:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZFFIl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 04:41:26 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:53107 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZFFIl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 04:41:26 -0400
Date: Sat, 6 Jun 2009 10:43:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Russell King <rmk+lkml@arm.linux.org.uk>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>, Ralf Baechle <ralf@linux-mips.org>,
       Michael Abbott <michael@araneidae.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/6] headers_check fix patches 20090604
Message-ID: <20090606084341.GB14555@uranus.ravnborg.org>
References: <1244118232.5172.26.camel@ht.satnam> <1244275812.2475.2.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244275812.2475.2.camel@ht.satnam>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 01:40:12PM +0530, Jaswinder Singh Rajput wrote:
> On Thu, 2009-06-04 at 17:53 +0530, Jaswinder Singh Rajput wrote:
> > Please Review :
> > 
> > Jaswinder Singh Rajput (6):
> >       headers_check fix: arm, hwcap.h
> >       headers_check fix: ia64, fpswa.h
> >       headers_check fix: m68k, swab.h
> >       headers_check fix: mips, ioctl.h
> >       headers_check fix: mn10300, ptrace.h
> >       headers_check fix: mn10300, setup.h
> 
> Thanks for you review, I applied all these patches to headers-check tree
> for linus :
> 
> http://git.kernel.org/?p=linux/kernel/git/jaswinder/headers-check-2.6.git;a=summary

We agreed to do mips different - right?

	Sam
