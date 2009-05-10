Return-Path: <linux-kernel-owner+w=401wt.eu-S1754553AbZEJVHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbZEJVHY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 17:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZEJVHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 17:07:09 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:50178 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbZEJVHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 17:07:08 -0400
Date: Sun, 10 May 2009 23:09:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Joe Perches <joe@perches.com>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       randy.dunlap@oracle.com, torvalds@linux-foundation.org, akpm@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: RFC: MAINTAINER email address style?
Message-ID: <20090510210918.GA22742@uranus.ravnborg.org>
References: <20090407081312.GH1408@ucw.cz> <1240415689.21848.19.camel@localhost> <20090422185916.GA3864@uranus.ravnborg.org> <20090422120510.cc17e470.akpm@linux-foundation.org> <1240430185.21848.103.camel@localhost> <20090422203005.GA467@elf.ucw.cz> <1240557233.6735.240.camel@localhost> <1241987200.3877.9.camel@Joe-AcerAspire> <20090510205326.GA22578@uranus.ravnborg.org> <1241989210.6711.5.camel@Joe-AcerAspire>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241989210.6711.5.camel@Joe-AcerAspire>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 02:00:10PM -0700, Joe Perches wrote:
> On Sun, 2009-05-10 at 22:53 +0200, Sam Ravnborg wrote:
> > On Sun, May 10, 2009 at 01:26:40PM -0700, Joe Perches wrote:
> > > Should names and email addresses in MAINTAINERS be integrated?
> > > Should it stay as-is or be changed to:
> > > 
> > > M: name <email>
> > > M: name2 <email2>
> > 
> > I strongly prefer this style. It fits the way I do
> > copy'n'paste of selected email addresses.
> > 
> > If I want to add Rafael in a Cc: line I have to
> > anually add "" to surround his name due to the "J." and I
> > have to manually add <>.
> > Typing in his email address is a no no - and I can spell
> > to Wysovski correct only a few times a day.
> 
> Exceeded your quota today already? ;)
> 

I prefer this style: 
> M:	Len Brown <len.brown@intel.com>
> M:	Pavel Machek <pavel@ucw.cz>
> M:	"Rafael J. Wysocki" <rjw@sisk.pl>

	Sam
