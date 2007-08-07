Return-Path: <linux-kernel-owner+w=401wt.eu-S934650AbXHGOsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934650AbXHGOsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbXHGOs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:48:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52780 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753240AbXHGOsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:48:25 -0400
Date: Tue, 7 Aug 2007 15:55:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Message-ID: <20070807155521.0dc9f068@the-village.bc.nu>
In-Reply-To: <1186496712.3414.17.camel@localhost.localdomain>
References: <1186248703.3439.20.camel@localhost.localdomain>
	<alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>
	<1186458941.6637.44.camel@localhost.localdomain>
	<20070807001429.f8cb3b22.akpm@linux-foundation.org>
	<1186496712.3414.17.camel@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I fully agree, and firmly believe that the current stabilisation works
> incredibly well for shaking out bugs.  My problem is that it doesn't
> work for stabilising features.  Either we have to get far more people
> doing feature integration testing before the merge window, or we have to
> accept feature updates after the merge window (for existing features
> that are having stability issues).

The other alternative is that if Linus won't take updates you ask him to
revert bsg so that you don't get a half baked merge as a result of this.
I'm not sure that is a good path to follow either however.

