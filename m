Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbYBFRpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbYBFRpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbYBFRpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:45:41 -0500
Received: from [198.99.130.12] ([198.99.130.12]:44518 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753814AbYBFRpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:45:40 -0500
Date: Wed, 6 Feb 2008 12:44:45 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/5] UML - Five for 2.6.25
Message-ID: <20080206174445.GA7866@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This batch should go into the 2.6.25 merge window.

There are a couple of patches which had been sitting in -mm waiting
for this merge window, but got lost somehow:
	runtime host vmsplit detection - Miklos spotted a bug, since
fixed, with a 32-bit UML on a 64-bit host
	style fixes in arch/um/os-Linux - there's a false-positive
checkpatch complaint with this one

The rest are bug fixes.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
