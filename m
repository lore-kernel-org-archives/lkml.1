Return-Path: <linux-kernel-owner+w=401wt.eu-S1753053AbXISBcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbXISBcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 21:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbXISBbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 21:31:42 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:49030 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbXISBbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 21:31:41 -0400
Date: Tue, 18 Sep 2007 21:31:22 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/2] UML - Two x86_64 build fixes
Message-ID: <20070919013122.GA10817@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches fix UML build breakages on x86_64.

They are -mm-specific, so don't need to go to mainline until 2.6.24.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
