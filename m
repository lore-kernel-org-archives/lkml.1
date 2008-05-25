Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYEYHNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYEYHNk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 03:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYEYHNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 03:13:33 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:44630 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbYEYHNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 03:13:32 -0400
Date: Sun, 25 May 2008 09:14:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Jike Song <albcamus@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [.gitignore] match ncscope.out
Message-ID: <20080525071411.GB32120@uranus.ravnborg.org>
References: <4834CAFE.2070607@gmail.com> <alpine.LNX.1.10.0805212246390.15136@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0805212246390.15136@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 10:47:28PM +0200, Jan Engelhardt wrote:
> 
> On Thursday 2008-05-22 03:23, Jike Song wrote:
> > ---
> > .gitignore |    2 +-
> > 1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/.gitignore b/.gitignore
> > index 090b293..a48b1e1 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -51,7 +51,7 @@ patches
> > series
> >
> > # cscope files
> > -cscope.*
> > +*cscope.*
> 
> Unless you know there is acscope, bcscope, etc. I'd rather add
> just ncscope.* instead of the catches-more *cscope.*.
I did this change when I applied it.

Thanks,
	Sam
