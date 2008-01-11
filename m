Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbYAKEXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbYAKEXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 23:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbYAKEXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 23:23:14 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:32398 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755025AbYAKEXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 23:23:13 -0500
Date: Fri, 11 Jan 2008 13:22:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.24-rc7
Message-ID: <20080111042254.GA30136@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.24.git

Which contains:

Carmelo Amoroso (1):
      sh: Fix argument page dcache flushing regression.

Paul Mundt (1):
      sh: Force __access_ok() to obey address space limit.

 include/asm-sh/cacheflush.h |    6 ++++++
 include/asm-sh/uaccess.h    |   42 +++++++++++++++---------------------------
 2 files changed, 21 insertions(+), 27 deletions(-)
