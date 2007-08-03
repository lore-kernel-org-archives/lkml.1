Return-Path: <linux-kernel-owner+w=401wt.eu-S1763396AbXHCR02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763396AbXHCR02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbXHCR0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:26:19 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48172 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221AbXHCR0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:26:18 -0400
Date: Fri, 3 Aug 2007 13:26:02 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/2] UML - Console fixes and cleanups for 2.6.24
Message-ID: <20070803172602.GA8257@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches fix the console write error that Miklos reported and
tidy up the code while I was in there.

They should hold off for 2.6.24 - the code with the bug that's being
fixed is also being held for 2.6.24.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
