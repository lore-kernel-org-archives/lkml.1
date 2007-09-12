Return-Path: <linux-kernel-owner+w=401wt.eu-S1763356AbXILEwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763356AbXILEwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 00:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbXILEwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 00:52:12 -0400
Received: from mxsf05.insightbb.com ([74.128.0.75]:7256 "EHLO
	mxsf05.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbXILEwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 00:52:11 -0400
X-IronPort-AV: E=Sophos;i="4.20,242,1186372800"; 
   d="scan'208";a="31546483"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CABIN50ZKjlCP/2dsb2JhbACBXQ
X-IronPort-AV: E=Sophos;i="4.20,242,1186372800"; 
   d="scan'208";a="125853859"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input updates for 2.6.23-rc6
Date: Wed, 12 Sep 2007 00:52:07 -0400
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709120052.07884.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for input subsystem.

Changelog:
----------
Elvis Pranskevichus (1):
      Input: i8042 - add HP Pavilion DV4270ca to the MUX blacklist

Ralf Baechle (1):
      Input: i8042 - fix modpost warning

Samuel Thibault (1):
      Input: add more Braille keycodes

Vladimir Shebordaev (1):
      Input: usbtouchscreen - correctly set 'phys'

Diffstat:
---------
 drivers/input/serio/i8042-x86ia64io.h      |   10 ++++++++++
 drivers/input/serio/i8042.c                |    2 +-
 drivers/input/touchscreen/usbtouchscreen.c |    2 +-
 include/linux/input.h                      |    2 ++
 include/linux/keyboard.h                   |    4 +++-
 5 files changed, 17 insertions(+), 3 deletions(-)

-- 
Dmitry
