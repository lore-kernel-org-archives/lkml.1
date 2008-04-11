Return-Path: <linux-kernel-owner+w=401wt.eu-S1761482AbYDKSkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761482AbYDKSkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 14:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760556AbYDKSj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 14:39:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52357 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760228AbYDKSj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 14:39:57 -0400
Date: Fri, 11 Apr 2008 19:36:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make ali_atapi_dma static
Message-ID: <20080411193608.16e7147b@core>
In-Reply-To: <20080411172827.GC25788@cs181133002.pp.htv.fi>
References: <20080411172827.GC25788@cs181133002.pp.htv.fi>
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

On Fri, 11 Apr 2008 20:28:27 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> This patch makes the needlessly global ali_atapi_dma static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Alan Cox <alan@redhat.com>
