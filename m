Return-Path: <linux-kernel-owner+w=401wt.eu-S1761979AbYEESzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761979AbYEESzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYEESzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:55:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42159 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752213AbYEESzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:55:06 -0400
Date: Mon, 5 May 2008 19:46:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@sunset.davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] unexport proc_clear_tty
Message-ID: <20080505194609.1b970915@core>
In-Reply-To: <20080505182932.GY17139@cs181133002.pp.htv.fi>
References: <20080505182932.GY17139@cs181133002.pp.htv.fi>
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

On Mon, 5 May 2008 21:29:32 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> With the removal of the Solaris binary emulation the export of 
> proc_clear_tty became unused.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> Acked-by: David S. Miller <davem@davemloft.net>

Acked-by: Alan Cox <alan@redhat.com>
