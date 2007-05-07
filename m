Return-Path: <linux-kernel-owner+w=401wt.eu-S966530AbXEGUZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966530AbXEGUZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966408AbXEGUZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:25:22 -0400
Received: from [198.99.130.12] ([198.99.130.12]:60202 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S966400AbXEGUZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:25:21 -0400
Date: Mon, 7 May 2007 16:20:17 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/5] UML fixes plus a linuxdoc tweak
Message-ID: <20070507202017.GA8531@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These five are 2.6.22 material.

In this batch, we have
	a UML build fix
	enabling SCSI on UML
	ifdefing a function for later removal
	build warnings turned into comments

In addition, a comment in kernel/irq/handle.c hadn't been updated to
reflect the alimination of the regs arguments in much of the IRQ path.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
