Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbXKZVDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbXKZVDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 16:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbXKZVDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:03:16 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:58920 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbXKZVDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:03:15 -0500
Date: Mon, 26 Nov 2007 16:02:31 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/2] UML - Two rediffs
Message-ID: <20071126210231.GA11579@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These two should wait for 2.6.25.

They are rediffs against rc3-mm1 after they conflicted with other
stuff last week.  In particular, the first one, which cleans up UML's
use of TASK_SIZE, is vulnerable to the a.out work.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
