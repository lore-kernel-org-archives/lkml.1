Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYGAIST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYGAIST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbYGAISF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:18:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43212 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753182AbYGAISC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:18:02 -0400
Date: Tue, 1 Jul 2008 08:59:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: <JosephChan@via.com.tw>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <geert@linux-m68k.org>
Subject: Re: [PATCH 7/13] viafb: iface.c, iface.h, ioctl.c, ioctl.h
Message-ID: <20080701085906.21688d20@lxorguk.ukuu.org.uk>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7D07@exchtp03.taipei.via.com.tw>
References: <20080630103939.23a24435@lxorguk.ukuu.org.uk>
	<C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7D07@exchtp03.taipei.via.com.tw>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008 09:20:31 +0800
<JosephChan@via.com.tw> wrote:

> Alan,
> 
> Thanks to remind.
> Is it good to add viafb_ , ex: viafb_get_memsize(void)?
> It would be great to have your comment. Thanks again.

It is yes - that way global symbols don't clash between modules
