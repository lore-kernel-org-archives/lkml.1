Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbXFOPft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbXFOPft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXFOPfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:35:41 -0400
Received: from [198.99.130.12] ([198.99.130.12]:37570 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbXFOPfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:35:40 -0400
Date: Fri, 15 Jun 2007 11:34:49 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/2] UML - Two for 2.6.22
Message-ID: <20070615153449.GA7715@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These two are for 2.6.22.

The first switches to the generic BUG support and adds a related build
fix.  The second is a build fix for configurations which pull in i386
headers which want paravirt.h.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
