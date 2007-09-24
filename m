Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbXIXKrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbXIXKrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 06:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbXIXKrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 06:47:00 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:62439 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbXIXKq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 06:46:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mG02iVQFm4nFuot4H9gYnLJN4rlmnOpEcOy8lY33FWqsy8iVdN73qcNeeIRQmFGqyyL6r0HDzOlTgqYLqKmd3qB6yvRLY5Do0/k7A9Ld1WoZhPjDgcmbDrbDZwWqR2zS8Xu2QFdD3oPP7wYs1hH2RHQcTWfr7WE+Vg4dXUU2/NM=
Message-ID: <3f9a31f40709240346o21eb48b8u518a1af72faa9e8f@mail.gmail.com>
Date: Mon, 24 Sep 2007 16:16:59 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: 2.6.22.7 autoconf.h is screwed up
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0709240637140.791@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40709240320mb213a7an87cee8bf5517d7f7@mail.gmail.com>
	 <Pine.LNX.4.64.0709240625140.31104@localhost.localdomain>
	 <3f9a31f40709240335w441699b5y366211baeebde871@mail.gmail.com>
	 <Pine.LNX.4.64.0709240637140.791@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello rday,

On 9/24/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Mon, 24 Sep 2007, Jaswinder Singh wrote:
>
> > hello rday,
> >
> > In my view autoconf.h is the index of kernel you are using. By
> > reading autoconf.h you will know what Architecture, drivers is
> > selected.
> >
> > For example, If we are using some ARM based board, If you give me
> > your autoconf.h , I can replicate same environment as yours. If it
> > is not properly formatted it is very difficult to read and come to
> > some conclusion.
>
> no, the proper thing to do is give someone your .config file if you
> want them to reproduce your configuration, and leave autoconf.h out of
> it.
>

yes, you are right. So autoconf.h is obsolete and replaced by .config
. And now autoconf.h looks so funny and scary that no body dares to
open autoconf.h in future ;-)


Thank you,

Jaswinder Singh.

> rday
> --
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
>
> http://crashcourse.ca
> ========================================================================
>
