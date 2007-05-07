Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbXEGVTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbXEGVTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbXEGVTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:19:50 -0400
Received: from [81.2.110.250] ([81.2.110.250]:45337 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754860AbXEGVTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:19:50 -0400
Date: Mon, 7 May 2007 22:23:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Message-ID: <20070507222311.4589fc8a@the-village.bc.nu>
In-Reply-To: <20070507194949.GB3981@ucw.cz>
References: <20070503213303.GH20067@zarina>
	<20070507140453.GD3868@ucw.cz>
	<1178550653.11851.191.camel@pmac.infradead.org>
	<20070507194949.GB3981@ucw.cz>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007 19:49:50 +0000
Pavel Machek <pavel@ucw.cz> wrote:

> On Mon 2007-05-07 16:10:53, David Woodhouse wrote:
> > On Mon, 2007-05-07 at 14:04 +0000, Pavel Machek wrote:
> > > Can we stick to ascii in sources? 
> > 
> > No. Please join us in the 21st century.
> 
> We had this discussion before. Kernel sources should be us-ascii.
> utf-8 is ok for documentation.

We had this discussion before. Kernel sources should use utf-8 for
comments where neccessary. Many names cannot be correctly represented in
US ascii, and mangling them is just plain rude.
