Return-Path: <linux-kernel-owner+w=401wt.eu-S1763256AbXGaXt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763256AbXGaXt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbXGaXtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:49:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34190 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753760AbXGaXtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:49:46 -0400
Date: Wed, 1 Aug 2007 00:56:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Vitaly Bordug <vitb@kernel.crashing.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/2] [POWERPC] MPC8349E-mITX: use platform IDE driver
 for CF	interface
Message-ID: <20070801005640.327226db@the-village.bc.nu>
In-Reply-To: <a414f3b506b7802a717e6e2c08befd1e@kernel.crashing.org>
References: <20070725165318.5331.23795.stgit@localhost.localdomain>
	<20070725165326.5331.19920.stgit@localhost.localdomain>
	<46A78322.3080607@ru.mvista.com>
	<46A78E3F.1030904@ru.mvista.com>
	<a414f3b506b7802a717e6e2c08befd1e@kernel.crashing.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The hardware is called (E)IDE, the protocol is called ATA.
> Or that's what I was told -- I think there's some historic
> revisionism involved, too.

ATA is the interface and standards for the ANSI standards based disk
attachment. IDE "Integrated Drive Electronics" is a marketing name used
to cover all sorts of ST412 compatible-ish early interfaces that moved
the brains onto the disk. IDE doesn't really mean much but "brains on
disk", ATA is a real standard.
