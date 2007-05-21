Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbXEUNga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbXEUNga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 09:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbXEUNgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 09:36:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57236 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755100AbXEUNgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 09:36:22 -0400
Date: Mon, 21 May 2007 14:40:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: linux-kernel@vger.kernel.org,
       jwoithe@physics.adelaide.edu.au (Jonathan Woithe)
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
Message-ID: <20070521144050.66f47c8c@the-village.bc.nu>
In-Reply-To: <200705210657.l4L6vKRT005158@turbo.physics.adelaide.edu.au>
References: <200705210657.l4L6vKRT005158@turbo.physics.adelaide.edu.au>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> What's interesting here is that 00:1f.2 and 00:1f.5 are both identified as
> "n port SATA" controllers even though one of them (I suspect 00:1f.5) is a
> PATA controller.  This may just be a typo in lspci's database though.


Later ICH is listed by the documentation I have as SATA only. I would
imagine there is a seperate Jmicron or Marvell PATA controller on the
system ?

