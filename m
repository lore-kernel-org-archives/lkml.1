Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbYKVLm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbYKVLm1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 06:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757931AbYKVLmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 06:42:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36078 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758116AbYKVLmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 06:42:09 -0500
Date: Sat, 22 Nov 2008 11:40:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
Cc: "Qinghuang Feng" <qhfeng.kernel@gmail.com>,
       "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] driver/net/*: remove redundant argument comments
Message-ID: <20081122114014.379f2762@lxorguk.ukuu.org.uk>
In-Reply-To: <9929d2390811212355j635e0e8iee0e53678efc5f09@mail.gmail.com>
References: <4927b790.0e0d6e0a.65cc.ffffcb05@mx.google.com>
	<9929d2390811212355j635e0e8iee0e53678efc5f09@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > - * @rx_ring: pointer to receive ring structure
> >  * @cleaned_count: number of buffers to allocate this pass
> >  **/
> >
> 
> NAK - rather than removing documentation, I would suggest improving
> the documentation.  

I would suggest reading the patch more carefully - there is no rx_ring
argument. The documentation in the header is stale.

