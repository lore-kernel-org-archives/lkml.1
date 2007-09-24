Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbXIXKfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbXIXKfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 06:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbXIXKf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 06:35:27 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:46031 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbXIXKf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 06:35:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lPaisSIn5q/sMME/zy6oFJXkWXOtQ+q+4vpDyFVUA1TPXM+I/bzPUBFrTqriXXMHpWLqq53Ns2Tt9hRVhVvm45XST+9QzteGi/Bh+xsKbq7TgSEnGsEWt8KI7A97JOcz2AvjbxKZxdH8r3JWWD2KXt6HBK7b3KGojCqQfzWi5hk=
Message-ID: <3f9a31f40709240335w441699b5y366211baeebde871@mail.gmail.com>
Date: Mon, 24 Sep 2007 16:05:25 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: 2.6.22.7 autoconf.h is screwed up
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0709240625140.31104@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40709240320mb213a7an87cee8bf5517d7f7@mail.gmail.com>
	 <Pine.LNX.4.64.0709240625140.31104@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hello rday,

In my view autoconf.h is the index of kernel you are using. By reading
autoconf.h you will know what Architecture, drivers is selected.

For example, If we are using some ARM based board, If you give me your
autoconf.h , I can replicate same environment as yours. If it is not
properly formatted it is very difficult to read and come to some
conclusion.

Thank you,

Jaswinder Singh.


On 9/24/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Mon, 24 Sep 2007, Jaswinder Singh wrote:
>
> > Hi all,
> >
> > 2.6.22.7's include/linux/autoconf.h is completely screwed up as
> > compare to 2.6.10's autoconf.h .
> >
> > 2.6.22.7 totally changed the meaning of autoconf.h
> ... snip ...
>
>  why do you care what autoconf.h looks like?  it's automatically
> generated, it's not something you should be messing with.
>
> rday
>
> --
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
>
> http://crashcourse.ca
> ========================================================================
>
