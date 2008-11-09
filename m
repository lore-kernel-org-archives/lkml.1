Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbYKIQMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbYKIQMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 11:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbYKIQMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 11:12:42 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:34765 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260AbYKIQMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 11:12:42 -0500
Subject: [git pull] regulator Kconfig fix for 2.6.28-rc4
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Nov 2008 16:12:36 +0000
Message-Id: <1226247156.6727.73.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

to receive the following regulator Kconfig fix

Takashi Iwai (1):
      regulator: Use menuconfig in Kconfig

 drivers/regulator/Kconfig |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

---

Thanks

Liam



