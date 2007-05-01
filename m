Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbXEAQj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbXEAQj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbXEAQj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:39:29 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39465 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754235AbXEAQj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:39:28 -0400
Date: Tue, 1 May 2007 17:40:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] to something appropriate (was Re: 2.6.22 -mm merge
 plans)
Message-ID: <20070501174033.2046f289@the-village.bc.nu>
In-Reply-To: <46376748.6020408@redhat.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<46368062.6000100@garzik.org>
	<20070430170919.45e4b42b.akpm@linux-foundation.org>
	<463688AD.1050903@garzik.org>
	<20070501004036.GS2819@sequoia.sous-sol.org>
	<46368DA5.7070003@garzik.org>
	<20070501045806.GA3697@kroah.com>
	<46376748.6020408@redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > But distros can easily add the device id to their kernel if needed, it
> > isn't something that the -stable tree shoud be accepting.  Otherwise, we
> > will be swamped with those types of patches...
> > 
> 
> Oh sure, leave the distros swamped with them instead. :)
> 
> And they all have to do it separately, meaning they don't stay in sync
> and they duplicate each other's work...

Well they *don't* have to work that separately. They could set up some
shared tree which would look suspiciously like what Greg is doing but
with the ID updates.... ;)
