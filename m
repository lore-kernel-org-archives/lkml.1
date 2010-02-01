Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab0BAPVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:21:24 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:47930 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab0BAPVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:21:23 -0500
Subject: [GIT PULL] regulator fix
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 15:21:18 +0000
Message-ID: <1265037678.3126.40.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following WM8350 regulator fix for v2.6.33-rc7.

Thanks.

Liam

---

The following changes since commit abe94c756c08d50566c09a65b9c7fe72f83071c5:
  Linus Torvalds (1):
        Linux 2.6.33-rc6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Mark Brown (1):
      regulator: Specify REGULATOR_CHANGE_STATUS for WM835x LED constraints

 drivers/regulator/wm8350-regulator.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


