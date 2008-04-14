Return-Path: <linux-kernel-owner+w=401wt.eu-S1762081AbYDNVMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762081AbYDNVMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbYDNVMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:12:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755586AbYDNVMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:12:35 -0400
Date: Mon, 14 Apr 2008 14:11:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: hch@infradead.org, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org,
       miklos@szeredi.hu, me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-Id: <20080414141139.10d4d4c0.akpm@linux-foundation.org>
In-Reply-To: <4803C4A8.7020304@garzik.org>
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org>
	<20080413080130.GA9622@infradead.org>
	<20080413012001.8d7967f4.akpm@linux-foundation.org>
	<20080413082815.GA20108@infradead.org>
	<E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	<1208121358.2700.4.camel@shinybook.infradead.org>
	<20080413154459.4b2f125d.akpm@linux-foundation.org>
	<20080413234920.63711ca7@core>
	<20080413161014.cb06964c.akpm@linux-foundation.org>
	<20080414091639.4bd3879d@core>
	<20080414084141.GA29113@infradead.org>
	<4803C4A8.7020304@garzik.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 16:55:04 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> See comments like those on Evgeniy's blog: 
> http://tservice.net.ru/~s0mbre/blog/devel/fs/2008_04_14.html

Sigh.  I've already addressed that.

A new filesystem such as the one he's working on would, one hopes, be used
by an increasing number of people.  Whereas I expect that the already-tiny
number of people who use OMFS will *fall* over time.


Guys, a few years ago Linus's rule of thumb for merging an FS was,
approximately, "it is already being shipped by distros".  The bar is _much_
lower than that now.  Largely because I personally think that it should be.

