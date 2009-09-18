Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbZIRGHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbZIRGHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZIRGHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:07:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35144 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbZIRGHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:07:39 -0400
Date: Thu, 17 Sep 2009 23:03:20 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
	maintenance disaster
Message-ID: <20090918060320.GD7104@kroah.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <20090917125759.GA4045@kroah.com> <20090917140548.4e6ee596@lxorguk.ukuu.org.uk> <20090917132909.GB4779@kroah.com> <20090917164325.38994b47@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917164325.38994b47@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 04:43:25PM +0100, Alan Cox wrote:
> > > I've seen nacks from Christoph and from Eric and it seems Al Viro has yet
> > > to review devtmpfs. I'd like to see Al's opinion personally.
> > 
> > That's fine, but as it's just using the standard tmpfs interfaces that
> > other in-kernel virtual filesystems use, it shouldn't need that much
> > review.  The code is quite small as well, and I thought Al was still on
> > an extended vacation.
> > 
> > This code has been reviewed and posted numerous times for over 6 months
> > now, which should be plenty of time for us to be waiting for a review,
> > don't you?
> 
> Christoph has already nacked the code and indicated some problems (albeit
> in his inimitably friendly fashion) so you had at least one review, you
> just apparently didn't like the answer.

No, he did not point out any technical problem with the code that I can
find.  I asked for details, but he's probably on a plane at the moment.
I'll see him in a few days, so we can discuss it there if needed.

thanks,

greg k-h
