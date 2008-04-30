Return-Path: <linux-kernel-owner+w=401wt.eu-S1764317AbYD3XwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764317AbYD3XwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbYD3XwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:52:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47294 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbYD3XwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:52:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 01:51:48 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
References: <20080429.190352.137408408.davem@davemloft.net> <200805010123.58247.rjw@sisk.pl> <alpine.DEB.1.10.0804301640110.7807@asgard>
In-Reply-To: <alpine.DEB.1.10.0804301640110.7807@asgard>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805010151.49679.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 of May 2008, david@lang.hm wrote:
> On Thu, 1 May 2008, Rafael J. Wysocki wrote:
> 
> > On Thursday, 1 of May 2008, Andrew Morton wrote:
> >> On Wed, 30 Apr 2008 15:31:22 -0700 (PDT)
> >> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> > Also, the patches that were thoroughly discussed during their development
> > should be regarded as more trustworthy than the ones that were not discussed
> > at all.
> 
> but you don't have any way of knowing how much discussion took place on 
> any particular patch. that discussion could have taken place in many 
> different places, and you don't have the ability to monitor them all.

Not at the moment, but there may be a way to do that if we think of it more
thoroughly.

One idea may be add a "Commented-by:" tag in which to place people who
provided valuable comments to the patch author and/or maintainer (as a comma
separated list, for example, in analogy with the email Cc lists), especially if
the patch has been changed as a result of the comments.

Thanks,
Rafael
