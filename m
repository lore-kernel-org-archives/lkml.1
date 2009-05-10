Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbZEJViY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbZEJViY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 17:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbZEJVgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 17:36:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40048 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbZEJVgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 17:36:16 -0400
Date: Sun, 10 May 2009 23:36:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, randy.dunlap@oracle.com,
       torvalds@linux-foundation.org, akpm@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: RFC: MAINTAINER email address style?
Message-ID: <20090510213611.GC30393@elf.ucw.cz>
References: <1240003652.31116.44.camel@localhost> <20090407081312.GH1408@ucw.cz> <1240415689.21848.19.camel@localhost> <20090422185916.GA3864@uranus.ravnborg.org> <20090422120510.cc17e470.akpm@linux-foundation.org> <1240430185.21848.103.camel@localhost> <20090422203005.GA467@elf.ucw.cz> <1240557233.6735.240.camel@localhost> <1241987200.3877.9.camel@Joe-AcerAspire> <20090510222441.0fc3fc5b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090510222441.0fc3fc5b@lxorguk.ukuu.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-05-10 22:24:41, Alan Cox wrote:
> 
> > > > P:      Len Brown now <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Rafael J. Wysocki <rjw@sisk.pl>
> > > > L:      linux-pm@lists.linux-foundation.org
> > > > S:      Supported
> > 
> > Is there a consensus/majority opinion on this?
> > 
> > Should names and email addresses in MAINTAINERS be integrated?
> > Should it stay as-is or be changed to:
> 
> Please leave it alone or it becomes a total PITA to parse.

Currently it is PITA to use... which is IMNSHO worse. <> is standard
email notation, and I do not think it is in any way hard to parse.

Plus... I believe most uses _are_ manual. Parsers can be fixed, humans
can not.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
