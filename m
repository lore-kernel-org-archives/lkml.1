Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZEVF0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZEVF0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 01:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbZEVF0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 01:26:42 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57187 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZEVF0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 01:26:41 -0400
Date: Fri, 22 May 2009 14:26:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.30-rc7
Message-ID: <20090522052634.GA14059@linux-sh.org>
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

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.30

Which contains:

Magnus Damm (2):
      sh: ap325 camera without i2c driver fix
      video: stop sh_mobile_lcdcfb only if started

 arch/sh/boards/board-ap325rxa.c  |    3 +++
 drivers/video/sh_mobile_lcdcfb.c |    7 ++++++-
 2 files changed, 9 insertions(+), 1 deletions(-)
