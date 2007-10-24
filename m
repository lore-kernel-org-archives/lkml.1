Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbXJXSDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbXJXSDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbXJXSDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:03:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42526 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752137AbXJXSDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:03:43 -0400
Date: Wed, 24 Oct 2007 19:05:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       alan@redhat.com, torvalds@linux-foundation.org, viro@ftp.linux.org.uk
Subject: Re: [2.6 patch] unexport sys_{open,read}
Message-ID: <20071024190507.1147b376@the-village.bc.nu>
In-Reply-To: <20071024102151.54bb1749@laptopd505.fenrus.org>
References: <20071024162434.GL30533@stusta.de>
	<20071024102151.54bb1749@laptopd505.fenrus.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The patch below finally exports sys_open and sys_read now that they're

unexports 8)

