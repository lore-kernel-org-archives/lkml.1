Return-Path: <linux-kernel-owner+w=401wt.eu-S933379AbXGLSwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbXGLSwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 14:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756748AbXGLSwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 14:52:37 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:35756 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334AbXGLSwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 14:52:37 -0400
Date: Thu, 12 Jul 2007 11:52:19 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.22.1
Message-ID: <20070712185219.GR4306@sequoia.sous-sol.org>
References: <20070710200637.GA5881@kroah.com> <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com> <20070712184106.GA22849@kroah.com> <29495f1d0707121146k7b3a7175l1fcb40877e59cfaf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29495f1d0707121146k7b3a7175l1fcb40877e59cfaf@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Nish Aravamudan (nish.aravamudan@gmail.com) wrote:
> On 7/12/07, Greg KH <greg@kroah.com> wrote:
> > That is a tree that Chris did, and I didn't realize we were maintaining
> > it as the "official" stable tree, that is why it is not mentioned in the
> > release notes :)
> 
> Fair enough -- it's just a little bit easier from my side for
> mirroring to only have to mirror one tree rather simply rather than
> pulling multiple trees into one (and thus having to add to the list as
> time goes on).
> 
> > I'll let Chris decide if he wishes to maintain it or not, Chris?

Nish, I think you might be the only user ;-)  I never figured out a nice
way to do this w/out having a coherency issue (well, triggers aside).
Ideally git would allow for something more transparent than
alternatives, actual moving view to another tree.  It's possible with
links, but that seems just dirty.  Short of that, do folks find the tree
useful?  If so, I can work on some better automation to keep it
up-to-date.

thanks,
-chris
