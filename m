Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbXKBPlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbXKBPlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbXKBPlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:41:00 -0400
Received: from [198.99.130.12] ([198.99.130.12]:60091 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbXKBPk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:40:59 -0400
Date: Fri, 2 Nov 2007 11:40:12 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/6] UML - Assorted cleanups and fixes for 2.6.25
Message-ID: <20071102154012.GA10293@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are for 2.6.25.  There are a couple of documentation
fixes, three patches cleaning up the code around host cmov detection,
and a fix to the earlier get_wchan patch.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
