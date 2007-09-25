Return-Path: <linux-kernel-owner+w=401wt.eu-S1759248AbXIYFpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248AbXIYFpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 01:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbXIYFo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 01:44:59 -0400
Received: from mxsf05.insightbb.com ([74.128.0.75]:44963 "EHLO
	mxsf05.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbXIYFo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 01:44:58 -0400
X-IronPort-AV: E=Sophos;i="4.20,294,1186372800"; 
   d="scan'208";a="48205606"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAMI8+EZKjlCP/2dsb2JhbACBWA
X-IronPort-AV: E=Sophos;i="4.20,294,1186372800"; 
   d="scan'208";a="119240772"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input updates for 2.6.23-rc8
Date: Tue, 25 Sep 2007 01:44:57 -0400
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709250144.57533.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. There is only one patch
that fixes regression in appletouch driver introduced in previous
release.

Thomas Rohwer (1):
      Input: appletouch - fix idle reset logic

 drivers/input/mouse/appletouch.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

-- 
Dmitry
