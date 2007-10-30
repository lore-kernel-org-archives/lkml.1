Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbXJ3Ra7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbXJ3Ra7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbXJ3R3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:29:40 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:43045 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbXJ3R3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:29:38 -0400
Date: Tue, 30 Oct 2007 13:28:48 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/4] UML - Four tidying patches for 2.6.25
Message-ID: <20071030172848.GA8377@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These four patches are non-urgent and should wait for 2.6.25.  Three
of them are code cleanup and the other is an implementation of
get_wchan, which no one has been complaining about.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
