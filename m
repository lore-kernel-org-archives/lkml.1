Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbZLLH7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbZLLH7h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 02:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbZLLH7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 02:59:36 -0500
Received: from mail.gmx.net ([213.165.64.20]:44097 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751562AbZLLH7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 02:59:35 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Okttu8PEOAlBsurnsFamRj8xp4OGwLRSbb4ZUo8
	8r/RvEck4X+7ZX
Subject: Re: BFS v0.311 CPU scheduler for 2.6.32
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200912120937.42943.kernel@kolivas.org>
References: <200912111124.18118.kernel@kolivas.org>
	 <200912120204.51547.kernel@kolivas.org>
	 <alpine.DEB.2.00.0912110910490.32415@router.home>
	 <200912120937.42943.kernel@kolivas.org>
Content-Type: text/plain
Date: Sat, 12 Dec 2009 08:59:39 +0100
Message-Id: <1260604779.6571.28.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-12 at 09:37 +1100, Con Kolivas wrote:
> On Sat, 12 Dec 2009 02:12:58 Christoph Lameter wrote:
> > On Sat, 12 Dec 2009, Con Kolivas wrote:
> > > On Sat, 12 Dec 2009 01:10:39 Christoph Lameter wrote:
> > > > Could you make the scheduler build time configurable instead of
> > > > replacing the existing one? Embedded folks in particular may love a low
> > > > footprint scheduler.
> > >
> > > It's not a bad idea, but the kernel still needs to be patched either way.
> > > To get BFS they'd need to patch the kernel. If they didn't want BFS, they
> > > wouldn't patch it in the first place.
> > 
> > BFS would have a chance to be merged as an alternate scheduler for
> > specialized situations (such as embedded or desktop use).
> > 
> 
> Nice idea, but regardless of who else might want that, the mainline 
> maintainers have already made it clear they do not.

Hm.  You made it very clear from the onset that BFS was not intended to
be a merge candidate.  Of course, you're free to change your mind any
time you feel like it.

	-Mike

