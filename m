Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbXDISTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbXDISTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbXDISTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:19:40 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:38295 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbXDISTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:19:39 -0400
Date: Mon, 9 Apr 2007 14:14:40 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/4] UML - Code cleanup and I/O path fixes
Message-ID: <20070409181440.GA7282@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are 2.6.22 material.

The first is just throwing out a pile of unused code.

The next three start to fix some rather code in UML's host file access
path.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
