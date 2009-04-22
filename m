Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZDVTLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZDVTLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbZDVTLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:11:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752625AbZDVTLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:11:08 -0400
Date: Wed, 22 Apr 2009 12:05:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: joe@perches.com, pavel@ucw.cz, randy.dunlap@oracle.com,
       torvalds@linux-foundation.org, akpm@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] MAINTAINERS - add script, patterns and misc
 updates
Message-Id: <20090422120510.cc17e470.akpm@linux-foundation.org>
In-Reply-To: <20090422185916.GA3864@uranus.ravnborg.org>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	<20090417134711.ba0f03e7.randy.dunlap@oracle.com>
	<1240003652.31116.44.camel@localhost>
	<20090407081312.GH1408@ucw.cz>
	<1240415689.21848.19.camel@localhost>
	<20090422185916.GA3864@uranus.ravnborg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 20:59:16 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Wed, Apr 22, 2009 at 08:54:49AM -0700, Joe Perches wrote:
> > On Tue, 2009-04-07 at 10:13 +0200, Pavel Machek wrote:
> > > > On Fri, 2009-04-17 at 13:47 -0700, Randy Dunlap wrote:
> > > > > I was hoping to get the patch that changed all pairs of
> > > > > P:
> > > > > M:
> > > > > lines to one line that is suitable for pasting into email addresses. 
> > > > I thought the P/M: integration was an unnecessary
> > > > complication that would delay pattern acceptance.
> > > 
> > > Well, P/M integration would help when using less/emacs to browse
> > > through maintainers then copy&paste using mouse... but yes, it makes
> > > sense to have it in separate patch :-).  
> > 
> > Is there agreement the P:/M: consolidation is useful?
> > No other scripts use the current style but get_maintainer?
> 
> It is irritating to manually copy name+email as it looks today.
> I always have to do that for the Cc: lines.
> 

me2
