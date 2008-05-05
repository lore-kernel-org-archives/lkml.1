Return-Path: <linux-kernel-owner+w=401wt.eu-S1760588AbYEESxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbYEESxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYEESxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:53:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37776 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751884AbYEESxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:53:34 -0400
Date: Mon, 5 May 2008 19:44:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Miloslav Trmac <mitr@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] remove is_tty()
Message-ID: <20080505194417.4ef0917d@core>
In-Reply-To: <20080505182134.GC17139@cs181133002.pp.htv.fi>
References: <20080505182134.GC17139@cs181133002.pp.htv.fi>
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

On Mon, 5 May 2008 21:21:34 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> This patch removes the no longer used is_tty().
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Alan Cox <alan@redhat.com>
