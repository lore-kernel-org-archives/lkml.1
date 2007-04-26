Return-Path: <linux-kernel-owner+w=401wt.eu-S1031476AbXDZUAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031476AbXDZUAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031484AbXDZUAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:00:21 -0400
Received: from [198.99.130.12] ([198.99.130.12]:49644 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1031476AbXDZUAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:00:19 -0400
Date: Thu, 26 Apr 2007 15:56:21 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/5] UML - Optimizations and fixes for 2.6.22
Message-ID: <20070426195621.GA9583@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patches 2 and 3 are more work on making tlb flushing more efficient.
Patches 1 and 4 are trivial.
Patch 5 fixes a problem with virtualized time not being fully virtual
with the kernel's current timekeeping.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
