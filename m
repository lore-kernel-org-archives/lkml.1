Return-Path: <linux-kernel-owner+w=401wt.eu-S932666AbXHWVkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbXHWVkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 17:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765714AbXHWVi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 17:38:27 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55553 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763523AbXHWViX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 17:38:23 -0400
Date: Thu, 23 Aug 2007 17:38:06 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/7] UML - Fixes for 2.6.24
Message-ID: <20070823213806.GA9085@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are for 2.6.24.

They are all fixes and cleanups -
	signal handling, ptrace, and core dump floating point fixes
	mconsole and sysrq fixes
	build fixes
	code cleanup

				Jeff
-- 
Work email - jdike at linux dot intel dot com
