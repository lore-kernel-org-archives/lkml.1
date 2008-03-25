Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbYCYTnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbYCYTnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYCYTmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 15:42:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39838 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750760AbYCYTmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 15:42:55 -0400
Date: Tue, 25 Mar 2008 19:26:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       eblennerhassett@audioscience.com
Subject: Re: [PATCH] scripts/Lindent - support gnu indent v2.2.10
Message-ID: <20080325192616.57018c0d@core>
In-Reply-To: <1206406054.4845.59.camel@localhost>
References: <1206406054.4845.59.camel@localhost>
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

On Mon, 24 Mar 2008 17:47:34 -0700
Joe Perches <joe@perches.com> wrote:

> The new version of indent supports positioning labels in column 1
> using "-il0"
> 
> http://www.nabble.com/Release-2.2.10-of-GNU-Indent-td15990700.html
> 
> Add "-il0" if indent version >= 2.2.10
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/scripts/Lindent b/scripts/Lindent

Acked-by: Alan Cox <alan@redhat.com>

Although I suspect some people may dislike that.
