Return-Path: <linux-kernel-owner+w=401wt.eu-S933947AbZJMQBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947AbZJMQBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933938AbZJMQBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:01:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:36636 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933937AbZJMQBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:01:40 -0400
Date: Tue, 13 Oct 2009 18:01:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID fixes
Message-ID: <alpine.LSU.2.00.0910131542070.8582@wotan.suse.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive HID fixes for 2.6.32. Thanks!

 drivers/hid/hid-core.c    |    2 +-
 drivers/hid/hid-twinhan.c |    4 ++--
 drivers/hid/hidraw.c      |    5 ++---
 3 files changed, 5 insertions(+), 6 deletions(-)

Jiri Kosina (2):
      HID: fix kerneldoc comment for hid_input_report()
      HID: fix possible deadlock in hidraw_read

Peter Huewe (1):
      HID: add __init/__exit macros to twinhan.c

