Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbZDTMbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbZDTMbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 08:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZDTMbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 08:31:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52020 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbZDTMbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 08:31:41 -0400
Date: Tue, 7 Apr 2009 10:13:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joe Perches <joe@perches.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] MAINTAINERS - add script, patterns and misc
	updates
Message-ID: <20090407081312.GH1408@ucw.cz>
References: <1239167872-8179-1-git-send-email-joe@perches.com> <20090417134711.ba0f03e7.randy.dunlap@oracle.com> <1240003652.31116.44.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240003652.31116.44.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On Fri, 2009-04-17 at 13:47 -0700, Randy Dunlap wrote:
> > On Tue,  7 Apr 2009 22:17:42 -0700 Joe Perches wrote:
> > I was hoping to get the patch that changed all pairs of
> > P:
> > M:
> > lines to one line that is suitable for pasting into email addresses.
> > Are we supposed to use get_maintainer.pl for that?
> 
> I merely wanted to get the patterns accepted.
> 
> I thought the P/M: integration was an unnecessary
> complication that would delay pattern acceptance.

Well, P/M integration would help when using less/emacs to browse
through maintainers then copy&paste using mouse... but yes, it makes
sense to have it in separate patch :-).  

Pavel -- (english)
http://www.livejournal.com/~pavelmachek (cesky, pictures)
http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
