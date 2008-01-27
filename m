Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbYA0MAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbYA0MAB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYA0L7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 06:59:53 -0500
Received: from ananke.telenet-ops.be ([195.130.137.78]:33506 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYA0L7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 06:59:53 -0500
Date: Sun, 27 Jan 2008 12:59:51 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: monstr@monstr.eu
cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: Re: Microblaze init port
In-Reply-To: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
Message-ID: <Pine.LNX.4.64.0801271258190.6736@anakin>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008, monstr@monstr.eu wrote:
> I personally feel the biggest pain in header files. 

26, 32, and 48 gave false positives in raising my interest :-)

+ * The user_ipc_perm structure for m68k architecture.
+ * The msqid64_ds structure for m68k architecture.
+ * The shmid64_ds structure for m68k architecture.
+ * The semid64_ds structure for m68k architecture.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
