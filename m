Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbYFLQ3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbYFLQ3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 12:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbYFLQ3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 12:29:17 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:52297 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbYFLQ3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 12:29:16 -0400
Date: Thu, 12 Jun 2008 12:28:41 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/2] UML - Two fixes for 2.6.26
Message-ID: <20080612162841.GA8402@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a couple small, but important fixes for 2.6.26.  One is a
compilation problem that I added recently, and the other is a fix for
UML crashing needlessly when the host's PTRACE_SYSEMU is broken.

    	     		     Jeff

-- 
Work email - jdike at linux dot intel dot com
