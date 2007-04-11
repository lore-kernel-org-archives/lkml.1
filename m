Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbXDKQHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbXDKQHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 12:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbXDKQHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 12:07:10 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:46147 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbXDKQHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 12:07:07 -0400
Date: Wed, 11 Apr 2007 12:01:25 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/4] UML - I/O improvements and small fixes
Message-ID: <20070411160125.GA6339@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are 2.6.22 material.  Two of them are improvements to the block
driver, one causes UML to dump core on a panic, and the other is a bug
fix.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
