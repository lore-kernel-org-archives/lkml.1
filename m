Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbZCSOrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbZCSOrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 10:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZCSOrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 10:47:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:48180 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbZCSOrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 10:47:32 -0400
Date: Thu, 19 Mar 2009 15:47:30 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID fixes for 2.6.29-rc
Message-ID: <alpine.LNX.2.00.0903191546190.14346@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please consider pulling from

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive two hiddev oops fixes that would be nice to have in .29 still. 
Thanks!

 drivers/hid/usbhid/hiddev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Johannes Weiner (2):
      HID: fix incorrect free in hiddev
      HID: fix waitqueue usage in hiddev

