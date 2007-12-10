Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbXLJSBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbXLJSBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 13:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXLJSBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 13:01:00 -0500
Received: from [198.99.130.12] ([198.99.130.12]:55200 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbXLJSA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 13:00:59 -0500
Date: Mon, 10 Dec 2007 13:00:06 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/5] UML - Five patches for 2.6.25
Message-ID: <20071210180006.GA9348@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend of the tlb.h patch from last week, plus four more
small fixes and cleanups.

They should wait for 2.6.25.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
