Return-Path: <linux-kernel-owner+w=401wt.eu-S1764169AbXE2I0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764169AbXE2I0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 04:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXE2I0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 04:26:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58374 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750968AbXE2I0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 04:26:31 -0400
Date: Tue, 29 May 2007 09:31:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM/ARM26: Enable arbitary speed tty ioctls and split
 input/output speed
Message-ID: <20070529093127.5521e4c7@the-village.bc.nu>
In-Reply-To: <20070528145632.7c0ec1c9.akpm@linux-foundation.org>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	<20070528193658.GF5737@flint.arm.linux.org.uk>
	<20070528145632.7c0ec1c9.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I think Alan's per-arch patch was dependent upon an earlier patch.  He
> fooled everyone by sending them out in random order, without sequence

Sorry about that - I forgot to do it initially so it didn't get ordered
sanely

> +struct termios_2 {

struct termios2

so I also sneaked in a typo. Clearly I need a holiday


Alan
