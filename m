Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbXEQJLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbXEQJLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 05:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbXEQJLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 05:11:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:33615 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753182AbXEQJLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 05:11:46 -0400
X-Authenticated: #428038
X-Provags-ID: V01U2FsdGVkX18xZigyui8xkm4+Q/FBAHGtUonA+O5O3vBjORSITo
	9JzwlRnJIhKzn/
Date: Thu, 17 May 2007 11:11:42 +0200
From: Matthias Andree <matthias.andree@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Dumping a process's pagetable entries?
Message-ID: <20070517091142.GA7441@merlin.emma.line.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Key: http://home.pages.de/~mandree/keys/GPGKEY.asc
User-Agent: Mutt/1.5.15 (2007-04-24)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[please remember to Cc: me on your replies]

Greetings,

is there an easy way to dump a process's pagetables from outside that
process?  Tools, /proc or /sys file or syscall that I missed?

Thanks in advance.

-- 
Matthias Andree
