Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYGUACr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYGUACr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYGUACj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:02:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:56700 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbYGUACj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:02:39 -0400
Subject: [PATCH 0/22] Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       David Woodhouse <dwmw2@infradead.org>, rth@twiddle.net,
       rmk@arm.linux.org.uk, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.jp,
       tony.luck@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
       ralf@linux-mips.org, matthew@wil.cx, schwidefsky@de.ibm.com,
       lethal@linux-sh.org, chris@zankel.net
Content-Type: text/plain
Date: Mon, 21 Jul 2008 03:51:40 +0530
Message-Id: <1216592500.3679.14.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following series of patches introduce asm/syscalls.h in various
architectures.

As per David Woodhouse suggestion I am sending one patch per
architecture.

Thank you,

Jaswinder Singh.


