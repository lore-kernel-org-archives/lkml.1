Return-Path: <linux-kernel-owner+w=401wt.eu-S965876AbXILVRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965876AbXILVRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 17:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763377AbXILVQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 17:16:59 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55955 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761572AbXILVQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 17:16:57 -0400
Date: Wed, 12 Sep 2007 17:16:42 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/11] UML - Tickless and timekeeping update
Message-ID: <20070912211642.GA10267@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset modernizes UML's timekeeping system.  There are a number
of cleanups, but the major items are clockevent and clocksource
support, followed by tickless support.

This is obviously 2.6.24 material.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
