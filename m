Return-Path: <linux-kernel-owner+w=401wt.eu-S1757088AbXIXVIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088AbXIXVIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbXIXVIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:08:34 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:35105 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756766AbXIXVId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:08:33 -0400
Date: Mon, 24 Sep 2007 17:08:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       akpm@linux-foundation.org, "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 6/7] Linux Kernel Markers - Documentation
Message-ID: <20070924210830.GA8554@Krystal>
References: <20070924105632.009aba7f.randy.dunlap@oracle.com> <20070924180041.GB2435@infradead.org> <20070924111318.f16cde07.randy.dunlap@oracle.com> <20070924181931.GA3810@infradead.org> <46F800A7.7090005@oracle.com> <20070924183042.GA4418@infradead.org> <46F806AB.1050509@oracle.com> <20070924185431.GA5618@infradead.org> <46F80863.2090102@oracle.com> <20070924133730.c9b7c0e6.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070924133730.c9b7c0e6.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:07:04 up 56 days, 21:25,  4 users,  load average: 0.72, 0.73, 0.75
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> On Mon, 24 Sep 2007 11:56:35 -0700 Randy Dunlap wrote:
> 
> > Christoph Hellwig wrote:
> > > On Mon, Sep 24, 2007 at 11:49:15AM -0700, Randy Dunlap wrote:
> > >> I think that samples are perfectly fine for documentation and
> > >> that the trace example is a good example.  I think that most people
> > >> who need something like that would need to customize it for their
> > >> specific needs anyway.
> > >>
> > >> We don't seem to be making progress...
> > > 
> > > Time to bring in a Tie-Breaker :)
> > 
> > Yes.  Is anyone else interested?   :(
> 
> 
> I guess that's everyone (except those who are sleeping).
> 
> Let's not hold up progress.  Just use samples/ for code.

Would you already have the 

Makefile
samples/Kconfig
samples/Makefile

core code handy per chance ? (and probably Kconfig sourcing in every
arch ?)

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
