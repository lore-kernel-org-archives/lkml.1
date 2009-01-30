Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbZA3V5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbZA3V5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 16:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZA3V5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 16:57:42 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:54953 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbZA3V5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 16:57:42 -0500
Subject: [GIT PULL] regulator fixes
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 21:57:38 +0000
Message-Id: <1233352658.6774.33.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following two regulator fixes.

Thanks

Liam

---

The following changes since commit 33bfad54b58cf05cfe6678c3ec9235d4bc8db4c2:
  Linus Torvalds (1):
        Allow opportunistic merging of VM_CAN_NONLINEAR areas

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Philipp Zabel (1):
      regulator: move bq24022 init back to module_init instead of subsys_initcall

Roel Kluin (1):
      leds: Fix bounds checking of wm8350->pmic.led

 drivers/regulator/bq24022.c          |    6 +-----
 drivers/regulator/wm8350-regulator.c |    2 +-
 2 files changed, 2 insertions(+), 6 deletions(-)


