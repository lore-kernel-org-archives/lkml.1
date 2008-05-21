Return-Path: <linux-kernel-owner+w=401wt.eu-S935185AbYEUS5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935185AbYEUS5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbYEUS5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:57:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:44443 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbYEUS5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:57:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kbiIbStosS13B+0giMCiH/7btHi3U1CEGxzAJQ13mMc4LxPwj2DItR3tAnKKuLdab0swwXgTOcXmEFJygDk9qrC3qmMD0TMUYDKDL1C4TQbb633SS0vx2eBoULWnY9CTL90m/x53QGUkIDqZGNVeCe8ONXZS0rXvjc9qM0I/UF8=
Date: Wed, 21 May 2008 22:57:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard
	indentation of arguments)
Message-ID: <20080521185725.GD6932@cvg>
References: <12113495282137-git-send-email-kongjianjun@gmail.com> <20080521083413.GM28946@ZenIV.linux.org.uk> <20080521015037.add0b78e.akpm@linux-foundation.org> <20080521103206.GA24545@infradead.org> <20080521120939.GF8581@mit.edu> <20080521104644.5b6f4e63.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521104644.5b6f4e63.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrew Morton - Wed, May 21, 2008 at 10:46:44AM -0700]
| On Wed, 21 May 2008 08:09:39 -0400 Theodore Tso <tytso@mit.edu> wrote:
| 
| > On Wed, May 21, 2008 at 06:32:06AM -0400, Christoph Hellwig wrote:
| > > On Wed, May 21, 2008 at 01:50:37AM -0700, Andrew Morton wrote:
| > > > Oh, what a marvellous way to encourage new contributors that was. Thank
| > > > you so much.
| > > > 
| > > > For the record: Al speaks only for himself and a lack of expressed
| > > > disagrement from others should not be taken as agreement.
| > > 
| > > But I'd like to second the opinion.  This is getting a little too far.
| > > We should rather try to at least enforce very basic standards a lot of
| > > the crap shoved in doesn't follow instead of wanking around about exact
| > > placement of whitespaces.
| > 
| > The real question is whether people who are wanking about whitespace
| > and spelling fixes in comments will graduate to writing real, useful
| > patches.  If they won't, there's no point to encouraging them.
| > 
| 
| Guys, get a clue.  It doesn't matter what that person did.  It is the
| effect upon *all* other potential developers which is so damaging here.
| Not upon this individual.
| 

Btw, we have CodingStyle, SubmittingPatches and other, but why don't
we have something like KernelNewbieGuide? Don't get me wrong, but
there could be written all rules about - what is good to do, what is bad.
So a newbiew who wants to be usefull for kernel could read it and decide
what should be done. /Don't beat me ;) / And of course I know about
kernelnewbie.org but this (even quite short) document could help I think.

		- Cyrill -
