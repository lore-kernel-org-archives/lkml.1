Return-Path: <linux-kernel-owner+w=401wt.eu-S1761515AbYHAWnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761515AbYHAWnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbYHAWlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:41:50 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:52124 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868AbYHAWlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:41:49 -0400
Date: Fri, 1 Aug 2008 18:41:24 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/14] UML - 2.6.25.x
Message-ID: <20080801224124.GA13717@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are my -stable patches for 2.6.25.14.

Note that one patch, patch 13 "Fix boot crash", was sent in for
2.6.26-stable and described then as being not for 2.6.25-stable.  The
patch which fixes various build problems, patch 12 "fix gcc ICEs and
unresolved externs", is here, thus requiring #13.

	   	     	      Jeff

-- 
Work email - jdike at linux dot intel dot com
