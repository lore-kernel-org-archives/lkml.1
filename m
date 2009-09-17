Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbZIQNEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbZIQNEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758526AbZIQNEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:04:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54069 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758411AbZIQNEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:04:40 -0400
Date: Thu, 17 Sep 2009 14:05:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
 maintenance disaster
Message-ID: <20090917140548.4e6ee596@lxorguk.ukuu.org.uk>
In-Reply-To: <20090917125759.GA4045@kroah.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<20090917125759.GA4045@kroah.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 05:57:59 -0700
Greg KH <greg@kroah.com> wrote:

> On Thu, Sep 17, 2009 at 01:23:39AM -0700, Eric W. Biederman wrote:
> > 
> > devtmpfs has numerous problems.  The once I see from a quick review.
> 
> <snip>
> 
> I'm confused, why did you not at least cc: Kay and I on this message, if
> I was a paranoid person, I would think that you were somehow trying to
> skirt around us for some unknown reason :(
> 
> I think Kay has raised the proper points already.

I've seen nacks from Christoph and from Eric and it seems Al Viro has yet
to review devtmpfs. I'd like to see Al's opinion personally.

Alan
