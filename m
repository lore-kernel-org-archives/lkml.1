Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbXDSX1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbXDSX1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbXDSX1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:27:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55738 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754261AbXDSX1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:27:49 -0400
Date: Fri, 20 Apr 2007 00:31:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: chris@pcburn.com, linux-kernel@vger.kernel.org
Subject: Re: GPL-incompatible Module Error Message
Message-ID: <20070420003111.376a44d2@the-village.bc.nu>
In-Reply-To: <f2b55d220704191558i6deadc08q6aa07360cadaaccc@mail.gmail.com>
References: <4627EED5.6020800@pcburn.com>
	<f2b55d220704191558i6deadc08q6aa07360cadaaccc@mail.gmail.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> What's happening is that some kernel developers don't like Linus's
> stance on binary-only drivers and are trying to circumvent the norms
> of software copyright law using EXPORT_SYMBOL_GPL.

The troll is back I see.

Why don't you give him some useful information instead

- Turn off the paravirt option - you don't need it, and its just bloat
and slows down the kernel. Then rebuild the kernel and other bits and it
should all work fine. 

The legality of the ati driver as a derivative work is another matter,
but I don't see what _GPL symbols have to do with its legality beyond
providing a hint.

Alan
 
