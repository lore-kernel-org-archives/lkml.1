Return-Path: <linux-kernel-owner+w=401wt.eu-S934157AbXC0Sba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157AbXC0Sba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934160AbXC0Sa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:30:58 -0400
Received: from [198.99.130.12] ([198.99.130.12]:45432 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934159AbXC0Saz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:30:55 -0400
Date: Tue, 27 Mar 2007 14:27:45 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/6] UML - small fixes for 2.6.22
Message-ID: <20070327182745.GA8426@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are all 2.6.22 material.  Patch 1 fixes what appears to be a
i386 compilation bug, so we'll want Andi's ack on that, probably.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
