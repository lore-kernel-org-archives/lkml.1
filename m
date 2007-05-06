Return-Path: <linux-kernel-owner+w=401wt.eu-S933602AbXEFLI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602AbXEFLI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 07:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933609AbXEFLI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 07:08:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47143 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933602AbXEFLI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 07:08:26 -0400
Date: Sun, 6 May 2007 12:08:21 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: Christoph Hellwig <hch@infradead.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: VMware, x86_64 and 2.6.21.
Message-ID: <20070506110821.GA1166@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Valdis.Kletnieks@vt.edu,
	Nigel Cunningham <nigel@nigel.suspend2.net>,
	Arjan van de Ven <arjan@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1177998147.8981.16.camel@nigel.suspend2.net> <1178031475.3448.0.camel@laptopd505.fenrus.org> <1178032456.13953.12.camel@nigel.suspend2.net> <20070505095609.GB9935@infradead.org> <18248.1178435773@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18248.1178435773@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 03:16:13AM -0400, Valdis.Kletnieks@vt.edu wrote:
> I'm not convinced it's *totally* off-topic.  I'll agree that third-party
> binaries are on their own as far as active support goes, but I don't see
> that it's off-topic to post a simple statement-of-fact like "2.6.mumble-rc1
> breaks <popular-driver-FOO>" just so it's a *known* issue and people who
> search the list archives don't spend forever re-inventing the wheel.  Also,
> it's quite *possible* that the binary module has tripped over a geniune
> regression or bug in the kernel.

Actually it's totally offtopic.  Not only are prorpitary module not
on the agenda at all here, but ones that poke into deep down kernel
internals should be expected to break every time.  Note to mention that
they are on the almost black side of the illegality scala for propritary
modules.


---end quoted text---
