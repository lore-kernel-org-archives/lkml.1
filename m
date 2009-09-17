Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbZIQPl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbZIQPl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbZIQPl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:41:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48573 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751728AbZIQPl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:41:57 -0400
Date: Thu, 17 Sep 2009 16:43:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
 maintenance disaster
Message-ID: <20090917164325.38994b47@lxorguk.ukuu.org.uk>
In-Reply-To: <20090917132909.GB4779@kroah.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<20090917125759.GA4045@kroah.com>
	<20090917140548.4e6ee596@lxorguk.ukuu.org.uk>
	<20090917132909.GB4779@kroah.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I've seen nacks from Christoph and from Eric and it seems Al Viro has yet
> > to review devtmpfs. I'd like to see Al's opinion personally.
> 
> That's fine, but as it's just using the standard tmpfs interfaces that
> other in-kernel virtual filesystems use, it shouldn't need that much
> review.  The code is quite small as well, and I thought Al was still on
> an extended vacation.
> 
> This code has been reviewed and posted numerous times for over 6 months
> now, which should be plenty of time for us to be waiting for a review,
> don't you?

Christoph has already nacked the code and indicated some problems (albeit
in his inimitably friendly fashion) so you had at least one review, you
just apparently didn't like the answer.

Alan
