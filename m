Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbYEWKyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbYEWKyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 06:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYEWKxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 06:53:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42013 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752827AbYEWKxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 06:53:53 -0400
Date: Fri, 23 May 2008 11:41:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Randolf Pohl" <randolf.pohl@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lcd: Push the BKL down into the driver ioctl handler
Message-ID: <20080523114116.68c87435@core>
In-Reply-To: <20080523090616.68380@gmx.net>
References: <20080523090616.68380@gmx.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 11:06:16 +0200
"Randolf Pohl" <randolf.pohl@gmx.de> wrote:

> 
> unlock_kernel() before return:
> 
> > Signed-off-by: Alan Cox <alan@redhat.com>

Thanks and well spotted

Alan
