Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbYHOPqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbYHOPqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbYHOPp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:45:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34177 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754020AbYHOPp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:45:56 -0400
Date: Fri, 15 Aug 2008 16:28:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25.11-97.fc9 (P): idr_remove called for id=236 which is not
 allocated
Message-ID: <20080815162848.08ff793c@lxorguk.ukuu.org.uk>
In-Reply-To: <19f34abd0808150827m5128c8f6wd517796d95227654@mail.gmail.com>
References: <19f34abd0808150811w2b77479fnead3ae6b527ad4dc@mail.gmail.com>
	<19f34abd0808150827m5128c8f6wd517796d95227654@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ida_remove called for id=112 which is not allocated.
> ida_remove called for id=67 which is not allocated.
> ida_remove called for id=191 which is not allocated.
> ida_remove called for id=23 which is not allocated.
> 
> ..and with no backtrace, so I guess it means "not harmful". Sorry for the noise.

Thats definitely not good and wants digging into further.
