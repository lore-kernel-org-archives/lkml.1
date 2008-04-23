Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbYDWGEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbYDWGEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 02:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbYDWGE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 02:04:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151AbYDWGEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 02:04:23 -0400
Date: Tue, 22 Apr 2008 23:02:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: rdunlap@xenotime.net, harvey.harrison@gmail.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
Subject: Re: [PATCH] mfd: kconfig exposing unbuildable driver
Message-Id: <20080422230238.48c50ea0.akpm@linux-foundation.org>
In-Reply-To: <20080422210153.GB21435@flint.arm.linux.org.uk>
References: <1208895950.24124.9.camel@brick>
	<20080422203334.GA9809@flint.arm.linux.org.uk>
	<Pine.LNX.4.64.0804221337550.19817@shark.he.net>
	<20080422204549.GA21435@flint.arm.linux.org.uk>
	<Pine.LNX.4.64.0804221346470.19817@shark.he.net>
	<20080422210153.GB21435@flint.arm.linux.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 22 Apr 2008 22:01:53 +0100 Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> On Tue, Apr 22, 2008 at 01:47:18PM -0700, Randy.Dunlap wrote:
> > On Tue, 22 Apr 2008, Russell King wrote:
> > > On Tue, Apr 22, 2008 at 01:38:28PM -0700, Randy.Dunlap wrote:
> > > > On Tue, 22 Apr 2008, Russell King wrote:
> > > > 
> > > > > That was my initial approach as well, which got shot down by Andrew
> > > > > Morton and others as being unacceptable.
> > > > 
> > > > where?
> > > 
> > > In private mail.
> > > 
> > > > why?
> > > 
> > > Well, first I need to gain the permission of Andrew to post his private
> > > message.  I'm not being subborn here - I _do_ _not_ reproduce private
> > > messages in public without prior permission.
> > 
> > Sure, understood.
> > 
> > > > Seems like we need to push back on that part.
> > > 
> > > Talk to Andrew then.
> > 
> > He is cc-ed (although traveling much this week IIRC).
> 
> In which case, since it's likely I won't get a reply in the next hour
> (which'll delay my response by 24 hours) let me paraphrase what Andrew
> said.
> 
> Andrew believes that it is beneficial to have other architectures,
> particularly x86, build other architectures drivers.

Well.  I pointed out that there are arguments either way, and I do tend to
think that the let-x86-compile-it-too approach is perhaps the better one,
but that's a 51%/49% opinion.  Others disagree and lots and lots of code
has gone the other way.  Do whatever you think best ;)

