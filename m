Return-Path: <linux-kernel-owner+w=401wt.eu-S935895AbZAPAEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935895AbZAPAEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935709AbZAPAC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:02:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43702
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935692AbZAPAC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:02:57 -0500
Date: Thu, 15 Jan 2009 16:02:59 -0800 (PST)
Message-Id: <20090115.160259.246293979.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this build fix for Sparc.

Thanks!

The following changes since commit 37a76bd4f1b716949fc38a6842e89f0ccb8384d0:
  Arjan van de Ven (1):
        async: fix __lowest_in_progress()

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Fix UP build failure.

 arch/sparc/kernel/sparc_ksyms_64.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)
