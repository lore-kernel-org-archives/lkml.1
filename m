Return-Path: <linux-kernel-owner+w=401wt.eu-S967043AbXEGV6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967043AbXEGV6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966976AbXEGV6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:58:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54383 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S966685AbXEGV6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:58:18 -0400
Date: Mon, 7 May 2007 23:02:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Pavel Machek" <pavel@ucw.cz>, "David Woodhouse" <dwmw2@infradead.org>,
       "Anton Vorontsov" <cbou@mail.ru>, "Greg KH" <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       "Andrew Morton" <akpm@osdl.org>
Subject: Re: [PATCH 8/8] One Laptop Per Child power/battery driver
Message-ID: <20070507230207.2a74e769@the-village.bc.nu>
In-Reply-To: <d120d5000705071455y309e88ebt921331fdf30e60d2@mail.gmail.com>
References: <20070503213303.GH20067@zarina>
	<20070507140453.GD3868@ucw.cz>
	<1178550653.11851.191.camel@pmac.infradead.org>
	<20070507194949.GB3981@ucw.cz>
	<20070507222311.4589fc8a@the-village.bc.nu>
	<d120d5000705071455y309e88ebt921331fdf30e60d2@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > We had this discussion before. Kernel sources should use utf-8 for
> > comments where neccessary. Many names cannot be correctly represented in
> > US ascii, and mangling them is just plain rude.
> 
> So should we all start writing our names in native alphabets? And comments too?

Well we do have comments in several languages already but I was only
suggesting names as the comment texts do provide useful info and need to
be readable.

Alan
