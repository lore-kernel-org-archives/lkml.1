Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbZCJG5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbZCJG5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 02:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZCJG5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 02:57:03 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49435 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZCJG5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 02:57:01 -0400
Date: Tue, 10 Mar 2009 15:52:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.29-rc8
Message-ID: <20090310065259.GE10393@linux-sh.org>
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

Magnus Damm (1):
      video: deferred io cleanup fix for sh_mobile_lcdcfb

Nobuhiro Iwamatsu (1):
      sh: Add media/soc_camera.h to board setup of Renesas AP325RXA

 arch/sh/boards/board-ap325rxa.c  |    1 +
 drivers/video/sh_mobile_lcdcfb.c |    6 ++----
 2 files changed, 3 insertions(+), 4 deletions(-)
