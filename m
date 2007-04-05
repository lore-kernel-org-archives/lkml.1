Return-Path: <linux-kernel-owner+w=401wt.eu-S1767297AbXDEU3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767297AbXDEU3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbXDEU3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:29:21 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:54274 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbXDEU3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:29:17 -0400
Date: Thu, 5 Apr 2007 16:24:51 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/4] UML - Four for 2.6.22
Message-ID: <20070405202451.GA8918@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These four are also 2.6.22 material.  They are -
	giving some drivers release methods so they can be
hot-unplugged without either the kernel or hch complaining
	delete a now-unused macro
	improved debugging output
	faster page table walking

				Jeff

-- 
Work email - jdike at linux dot intel dot com
