Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYD2JI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYD2JI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYD2JIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:08:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39242 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753018AbYD2JIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:08:47 -0400
Date: Tue, 29 Apr 2008 10:01:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429100107.79ebf0cc@core>
In-Reply-To: <20080428230524.GK8474@1wt.eu>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi>
	<20080428230524.GK8474@1wt.eu>
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

> In fact, I would have better converted accentuated chars to their ASCII
> equivalent to be more friendly with people who only read 7-bit.

Perhaps we should put them in latin as well just in case any Roman is
struggling with this new language 8) Distibutions have been shipping UTF
enabled by default for years and years.

Alan
