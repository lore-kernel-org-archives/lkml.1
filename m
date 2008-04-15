Return-Path: <linux-kernel-owner+w=401wt.eu-S1760204AbYDOKDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbYDOKDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 06:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbYDOKCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 06:02:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42860 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754834AbYDOKCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 06:02:51 -0400
Date: Tue, 15 Apr 2008 10:58:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: fix routine name in ptmx_open()
Message-ID: <20080415105821.768470a6@core>
In-Reply-To: <4803FD15.6030006@ct.jp.nec.com>
References: <4803FD15.6030006@ct.jp.nec.com>
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

On Mon, 14 Apr 2008 17:55:49 -0700
Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> At ptmx_open(), the 2nd parameter for check_tty_count() should
> be "ptmx_open".
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Acked-by: Alan Cox <alan@redhat.com>
