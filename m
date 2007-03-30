Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbXC3Q7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbXC3Q7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 12:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbXC3Q7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 12:59:12 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41722 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbXC3Q7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 12:59:11 -0400
Date: Fri, 30 Mar 2007 09:59:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm3
Message-Id: <20070330095908.baf6ccb5.akpm@linux-foundation.org>
In-Reply-To: <d120d5000703300938j564a82bdq1e95eeab67a37221@mail.gmail.com>
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
	<d120d5000703300938j564a82bdq1e95eeab67a37221@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 12:38:11 -0400 "Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:

> On 3/30/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm3/
> >
> > - git-cryptodev has things in it again
> >
> > - Re-added git-e1000: a large amount of e1000 driver work
> >
> > - git-net has a huge amount of material in it, but I dropped it because it
> >  went oops.
> >
> > - git-block is back, minus the problematic unplugging rework.
> >
> > - Lots of x86 updates.
> >
> > - lguest is being redone and has been dropped
> >
> > - The IDE development tree has been restored
> >
> 
> Andrew,
> 
> Did you drop git-input? I do not see it anywhere....
> 

hm, odd, my git-input pull came up with a short changelog and no diff, so
it was decided that the tree was empty.  I don't know what could have
caused that.  Seems OK now though.

