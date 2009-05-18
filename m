Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbZERSBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbZERSBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 14:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZERSBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 14:01:37 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:36906 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZERSBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 14:01:36 -0400
Subject: [GIT PULL] voltage regulator fix for 2.6.30
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 May 2009 19:01:27 +0100
Message-Id: <1242669687.5473.2539.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following voltage regulator change that fixes a build
error when hotplug is disabled.

Thanks

Liam

---

The following changes since commit 45d447406a19cbfd42720f066f156f4eb9d68801:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../czankel/xtensa-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Mike Frysinger (1):
      regulator: da903x: add missing __devexit_p()

 drivers/regulator/da903x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


