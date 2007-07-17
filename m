Return-Path: <linux-kernel-owner+w=401wt.eu-S933646AbXGQQeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646AbXGQQeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbXGQQei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:34:38 -0400
Received: from [198.99.130.12] ([198.99.130.12]:39069 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbXGQQeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:34:37 -0400
Date: Tue, 17 Jul 2007 12:33:28 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       zippel@linux-m68k.org, jdike@karaya.com, alan@lxorguk.ukuu.org.uk,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: uninline check_signature()
Message-ID: <20070717163328.GG7965@c2.user-mode-linux.org>
References: <200707161802.l6GI2tNp007390@hera.kernel.org> <20070716221257.GA12230@osiris.ibm.com> <20070716152923.ce4a5c5a.akpm@linux-foundation.org> <alpine.LFD.0.999.0707161532190.20061@woody.linux-foundation.org> <20070716230307.GB12230@osiris.ibm.com> <Pine.LNX.4.64.0707171519300.10600@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707171519300.10600@anakin>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 03:22:16PM +0200, Geert Uytterhoeven wrote:
> I saw this patch went in.
> 
> iomap_copy.o ues the raw I/O memory accessors, so it truly depends on
> CONFIG_HAS_IOMEM.

This works for UML.

		Jeff

-- 
Work email - jdike at linux dot intel dot com
