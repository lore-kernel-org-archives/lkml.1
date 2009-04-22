Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbZDVS52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbZDVS52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 14:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbZDVS5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 14:57:13 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:37775 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbZDVS5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 14:57:11 -0400
Date: Wed, 22 Apr 2009 20:59:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Joe Perches <joe@perches.com>
Cc: Pavel Machek <pavel@ucw.cz>, Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] MAINTAINERS - add script, patterns and misc updates
Message-ID: <20090422185916.GA3864@uranus.ravnborg.org>
References: <1239167872-8179-1-git-send-email-joe@perches.com> <20090417134711.ba0f03e7.randy.dunlap@oracle.com> <1240003652.31116.44.camel@localhost> <20090407081312.GH1408@ucw.cz> <1240415689.21848.19.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240415689.21848.19.camel@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 08:54:49AM -0700, Joe Perches wrote:
> On Tue, 2009-04-07 at 10:13 +0200, Pavel Machek wrote:
> > > On Fri, 2009-04-17 at 13:47 -0700, Randy Dunlap wrote:
> > > > I was hoping to get the patch that changed all pairs of
> > > > P:
> > > > M:
> > > > lines to one line that is suitable for pasting into email addresses. 
> > > I thought the P/M: integration was an unnecessary
> > > complication that would delay pattern acceptance.
> > 
> > Well, P/M integration would help when using less/emacs to browse
> > through maintainers then copy&paste using mouse... but yes, it makes
> > sense to have it in separate patch :-).  
> 
> Is there agreement the P:/M: consolidation is useful?
> No other scripts use the current style but get_maintainer?

It is irritating to manually copy name+email as it looks today.
I always have to do that for the Cc: lines.

	Sam
