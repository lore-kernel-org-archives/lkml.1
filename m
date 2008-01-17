Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbYAQVoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbYAQVoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbYAQVli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:41:38 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:44784 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070AbYAQVlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:41:36 -0500
Date: Thu, 17 Jan 2008 16:40:37 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/20] UML - Lots of patches for 2.6.25
Message-ID: <20080117214037.GA6727@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a lot of cleanup.  There are style fixes, printk fixes,
spelling fixes, mutex conversions, and small bug fixes.

This is all obviously for 2.6.25.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
