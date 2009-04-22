Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbZDVP5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbZDVP5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbZDVP4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:56:42 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3250 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047AbZDVP4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:56:41 -0400
Subject: Re: [PATCH 0/10] MAINTAINERS - add script, patterns and misc
 updates
From: Joe Perches <joe@perches.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090407081312.GH1408@ucw.cz>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	 <20090417134711.ba0f03e7.randy.dunlap@oracle.com>
	 <1240003652.31116.44.camel@localhost>  <20090407081312.GH1408@ucw.cz>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 08:54:49 -0700
Message-Id: <1240415689.21848.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 10:13 +0200, Pavel Machek wrote:
> > On Fri, 2009-04-17 at 13:47 -0700, Randy Dunlap wrote:
> > > I was hoping to get the patch that changed all pairs of
> > > P:
> > > M:
> > > lines to one line that is suitable for pasting into email addresses. 
> > I thought the P/M: integration was an unnecessary
> > complication that would delay pattern acceptance.
> 
> Well, P/M integration would help when using less/emacs to browse
> through maintainers then copy&paste using mouse... but yes, it makes
> sense to have it in separate patch :-).  

Is there agreement the P:/M: consolidation is useful?
No other scripts use the current style but get_maintainer?
If so, I'll submit it this week along with some other
patches.

