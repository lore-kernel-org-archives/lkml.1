Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbZGUQI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbZGUQI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbZGUQIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:08:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116AbZGUQIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:08:52 -0400
Date: Tue, 21 Jul 2009 18:08:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID fixes for 2.6.31-rc3
Message-ID: <alpine.LNX.2.00.0907211750490.11648@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive fixes for HID code which should go into 2.6.31.

Thanks.

 drivers/hid/hid-core.c      |    6 ++++--
 drivers/hid/usbhid/hiddev.c |    4 +++-
 2 files changed, 7 insertions(+), 3 deletions(-)

Jiri Slaby (1):
      HID: hiddev, fix lock imbalance

Julia Lawall (1):
      HID: Move dereferences below a NULL test

