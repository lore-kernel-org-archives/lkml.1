Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbXFMOng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbXFMOng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 10:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbXFMOn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 10:43:29 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55900 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772AbXFMOn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 10:43:29 -0400
Date: Wed, 13 Jun 2007 10:42:44 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/2] UML bug fixes and cleanups
Message-ID: <20070613144244.GA5772@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These two are for 2.6.22.  We have a patch which makes UML boot with
DEBUG_SHIRQ enabled and one which cleans up the xterm driver.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
