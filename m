Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbYFMEQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbYFMEQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 00:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbYFMEPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 00:15:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35678
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750701AbYFMEPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 00:15:50 -0400
Date: Thu, 12 Jun 2008 21:15:50 -0700 (PDT)
Message-Id: <20080612.211550.160748198.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get this Sparc bug fix, thanks!

The following changes since commit 399dc43bc29fe1ac19340c56c0df84aa0ea53c85:
  Alexey Dobriyan (1):
        sparc: switch /proc/led to seq_file

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Robert Reif (1):
      sparc: get leo framebuffer working

 drivers/video/leo.c |   58 ++++++++++++++++++++++----------------------------
 1 files changed, 26 insertions(+), 32 deletions(-)
