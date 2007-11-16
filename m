Return-Path: <linux-kernel-owner+w=401wt.eu-S934869AbXKPVnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934869AbXKPVnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757828AbXKPVmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:42:49 -0500
Received: from [198.99.130.12] ([198.99.130.12]:59844 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbXKPVms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:42:48 -0500
Date: Fri, 16 Nov 2007 16:42:24 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/8] UML - Stub page updates for 2.6.25
Message-ID: <20071116214224.GA13887@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are for 2.6.25.  They change the code that handles stub
pages - a complete description of the patchset is included with the
first patch.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
