Return-Path: <linux-kernel-owner+w=401wt.eu-S1161618AbXD3AKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161618AbXD3AKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 20:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161611AbXD3AKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 20:10:40 -0400
Received: from waste.org ([66.93.16.53]:40880 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161602AbXD3AJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 20:09:49 -0400
Date: Sun, 29 Apr 2007 19:09:25 -0500
From: Matt Mackall <mpm@selenic.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
Message-ID: <20070430000925.GK11115@waste.org>
References: <20070425143011.57247c1d.akpm@linux-foundation.org> <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com> <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org> <20070428030805.GA13331@redhat.com> <20070428161136.GL11166@waste.org> <20070428171101.GC20646@redhat.com> <20070428172154.GA11115@waste.org> <20070429163701.fb994561.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429163701.fb994561.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 04:37:01PM -0700, Randy Dunlap wrote:
> On Sat, 28 Apr 2007 12:21:54 -0500 Matt Mackall wrote:
> 
> > On Sat, Apr 28, 2007 at 01:11:01PM -0400, Dave Jones wrote:
> > > On Sat, Apr 28, 2007 at 11:11:36AM -0500, Matt Mackall wrote:
> > >  > > I'm all ears for additional regexps, bug reports or other suggestions.
> > >  > 
> > >  > Neat.
> > >  > 
> > >  > Does it check for:
> > >  > 
> > >  > functions marked extern?
> 
> 	data marked extern?

It's perfectly reasonable to have a data extern declaration in a header file.

-- 
Mathematics is the supreme nostalgia of our time.
