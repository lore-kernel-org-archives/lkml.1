Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZEJUv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZEJUv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 16:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZEJUvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 16:51:17 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:55975 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbZEJUvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 16:51:17 -0400
Date: Sun, 10 May 2009 22:53:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Joe Perches <joe@perches.com>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       randy.dunlap@oracle.com, torvalds@linux-foundation.org, akpm@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: RFC: MAINTAINER email address style?
Message-ID: <20090510205326.GA22578@uranus.ravnborg.org>
References: <20090417134711.ba0f03e7.randy.dunlap@oracle.com> <1240003652.31116.44.camel@localhost> <20090407081312.GH1408@ucw.cz> <1240415689.21848.19.camel@localhost> <20090422185916.GA3864@uranus.ravnborg.org> <20090422120510.cc17e470.akpm@linux-foundation.org> <1240430185.21848.103.camel@localhost> <20090422203005.GA467@elf.ucw.cz> <1240557233.6735.240.camel@localhost> <1241987200.3877.9.camel@Joe-AcerAspire>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241987200.3877.9.camel@Joe-AcerAspire>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 01:26:40PM -0700, Joe Perches wrote:
> On Fri, 2009-04-24 at 00:13 -0700, Joe Perches wrote: 
> > On Wed, 2009-04-22 at 22:30 +0200, Pavel Machek wrote:
> > > If possible, it would be nice to aggregate multiple entries onto one
> > > line. I.e.:
> > > P:      Len Brown
> > > M:      len.brown@intel.com
> > > P:      Pavel Machek
> > > M:      pavel@ucw.cz
> > > P:      Rafael J. Wysocki
> > > M:      rjw@sisk.pl
> > > L:      linux-pm@lists.linux-foundation.org
> > > S:      Supported
> > > 
> > > ->
> > > 
> > > P:      Len Brown now <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Rafael J. Wysocki <rjw@sisk.pl>
> > > L:      linux-pm@lists.linux-foundation.org
> > > S:      Supported
> 
> Is there a consensus/majority opinion on this?
> 
> Should names and email addresses in MAINTAINERS be integrated?
> Should it stay as-is or be changed to:
> 
> M: name <email>
> M: name2 <email2>

I strongly prefer this style. It fits the way I do
copy'n'paste of selected email addresses.

If I want to add Rafael in a Cc: line I have to
anually add "" to surround his name due to the "J." and I
have to manually add <>.
Typing in his email address is a no no - and I can spell
to Wysovski correct only a few times a day.

	Sam
