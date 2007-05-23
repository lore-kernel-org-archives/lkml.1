Return-Path: <linux-kernel-owner+w=401wt.eu-S935035AbXEWQj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935035AbXEWQj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758524AbXEWQjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:39:49 -0400
Received: from [198.99.130.12] ([198.99.130.12]:34971 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758032AbXEWQjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:39:48 -0400
Date: Wed, 23 May 2007 12:32:57 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/2] UML - Two bug fixes for 2.6.22
Message-ID: <20070523163257.GA5568@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One of them is really more a workaround for a host bug than a UML bug
fix, but it does robustify the early boot checks a bit, and makes UML
boot on current FC6, so it's worth going in 2.6.22.

The other is a trivial error return fix in the ubd driver.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
