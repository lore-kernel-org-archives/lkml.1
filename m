Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706Ab0ANXpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab0ANXpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593Ab0ANXpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:45:10 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:48587 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab0ANXpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:45:09 -0500
Date: Fri, 15 Jan 2010 08:45:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.33-rc5
Message-ID: <20100114234504.GC25018@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.33

Which contains:

Markus Pietrek (1):
      serial: sh-sci: using correct fifo size for SCIF and SCIFA ports.

NISHIMOTO Hiroki (1):
      sh: mach-ecovec24: Add motion sensor driver support.

 arch/sh/boards/mach-ecovec24/setup.c |    8 ++++++++
 drivers/serial/sh-sci.c              |   13 ++++++++++++-
 2 files changed, 20 insertions(+), 1 deletions(-)
