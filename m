Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbZB0G5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbZB0G5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 01:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbZB0G5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 01:57:35 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39184 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbZB0G5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 01:57:34 -0500
Date: Fri, 27 Feb 2009 15:53:50 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.29-rc7
Message-ID: <20090227065350.GB28802@linux-sh.org>
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

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.29

Which contains:

Kuninori Morimoto (1):
      serial: sh-sci: fix overrun error handling for SH7785 SCIF.

Paul Mundt (1):
      sh: ap325rxa: Revert ov772x support.

Tobias Klauser (1):
      sh: Storage class should be before const qualifier

 arch/sh/boards/board-ap325rxa.c        |   53 ++------------------------------
 arch/sh/kernel/cpu/sh2a/clock-sh7201.c |    4 +-
 drivers/serial/sh-sci.h                |    2 +-
 3 files changed, 6 insertions(+), 53 deletions(-)
