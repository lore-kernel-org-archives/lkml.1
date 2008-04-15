Return-Path: <linux-kernel-owner+w=401wt.eu-S1762305AbYDOTVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762305AbYDOTVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbYDOTVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:21:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51287 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753411AbYDOTVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:21:30 -0400
Date: Tue, 15 Apr 2008 19:53:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, me@bobcopeland.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080415195330.17f63348@the-village.bc.nu>
In-Reply-To: <20080415113452.e9eacb54.akpm@linux-foundation.org>
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org>
	<20080413080130.GA9622@infradead.org>
	<20080413012001.8d7967f4.akpm@linux-foundation.org>
	<20080413082815.GA20108@infradead.org>
	<E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	<1208121358.2700.4.camel@shinybook.infradead.org>
	<20080413154459.4b2f125d.akpm@linux-foundation.org>
	<20080413234920.63711ca7@core>
	<20080413161014.cb06964c.akpm@linux-foundation.org>
	<20080415151643.GD2454@cs181133002.pp.htv.fi>
	<20080415165727.GA8783@infradead.org>
	<20080415113452.e9eacb54.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You can continue to ignore my logic, but that won't go unnoticed.
> 
> Just as a thought exercise: should we merge a small and well-written
> driver which has zero users?

We've previously merged ones that fit this category and have one user. If
the driver doesn't disrupt core code and is useful to help other people
write drivers then I think we should. It may also get more users as a
result.

This is a free software project not a business enterprise.

Alan

