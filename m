Return-Path: <linux-kernel-owner+w=401wt.eu-S936745AbYEUTe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936745AbYEUTe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 15:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935863AbYEUTd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 15:33:59 -0400
Received: from xenotime.net ([66.160.160.81]:44296 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934547AbYEUTd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 15:33:58 -0400
Date: Wed, 21 May 2008 12:33:55 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard
 indentation of arguments)
Message-Id: <20080521123355.b34f07ad.rdunlap@xenotime.net>
In-Reply-To: <20080521185725.GD6932@cvg>
References: <12113495282137-git-send-email-kongjianjun@gmail.com>
	<20080521083413.GM28946@ZenIV.linux.org.uk>
	<20080521015037.add0b78e.akpm@linux-foundation.org>
	<20080521103206.GA24545@infradead.org>
	<20080521120939.GF8581@mit.edu>
	<20080521104644.5b6f4e63.akpm@linux-foundation.org>
	<20080521185725.GD6932@cvg>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 22:57:25 +0400 Cyrill Gorcunov wrote:

> [Andrew Morton - Wed, May 21, 2008 at 10:46:44AM -0700]
> | On Wed, 21 May 2008 08:09:39 -0400 Theodore Tso <tytso@mit.edu> wrote:
> | 
> | > On Wed, May 21, 2008 at 06:32:06AM -0400, Christoph Hellwig wrote:
> | > > On Wed, May 21, 2008 at 01:50:37AM -0700, Andrew Morton wrote:
> | > > > Oh, what a marvellous way to encourage new contributors that was. Thank
> | > > > you so much.
> | > > > 
> | > > > For the record: Al speaks only for himself and a lack of expressed
> | > > > disagrement from others should not be taken as agreement.
> | > > 
> | > > But I'd like to second the opinion.  This is getting a little too far.
> | > > We should rather try to at least enforce very basic standards a lot of
> | > > the crap shoved in doesn't follow instead of wanking around about exact
> | > > placement of whitespaces.
> | > 
> | > The real question is whether people who are wanking about whitespace
> | > and spelling fixes in comments will graduate to writing real, useful
> | > patches.  If they won't, there's no point to encouraging them.
> | > 
> | 
> | Guys, get a clue.  It doesn't matter what that person did.  It is the
> | effect upon *all* other potential developers which is so damaging here.
> | Not upon this individual.
> | 
> 
> Btw, we have CodingStyle, SubmittingPatches and other, but why don't
> we have something like KernelNewbieGuide? Don't get me wrong, but
> there could be written all rules about - what is good to do, what is bad.
> So a newbiew who wants to be usefull for kernel could read it and decide
> what should be done. /Don't beat me ;) / And of course I know about
> kernelnewbie.org but this (even quite short) document could help I think.

I did a talk on Linux "social engineering" at {OSCON, IEEE NW something,
and SCALE}.  All about what (not) to do, how to do it, etc.
Slides for it are available in http://www.xenotime.net/linux/mentor/ .


---
~Randy
