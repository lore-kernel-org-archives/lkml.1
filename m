Return-Path: <linux-kernel-owner+w=401wt.eu-S1031413AbXEDRoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031413AbXEDRoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031433AbXEDRoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:44:39 -0400
Received: from [198.99.130.12] ([198.99.130.12]:51055 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1031413AbXEDRoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:44:38 -0400
Date: Fri, 4 May 2007 13:39:56 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/3] Small UML fixes
Message-ID: <20070504173956.GA7936@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are for 2.6.22.

We have a hostfs fix and hostfs style fixes in the first two.

The third fixes the load average on an idle system.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
