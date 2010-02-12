Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab0BLOey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 09:34:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:49095 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab0BLOex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 09:34:53 -0500
Subject: [GIT PULL] regulator fixes for 2.6.33
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Feb 2010 14:34:48 +0000
Message-ID: <1265985288.3231.14.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following two regulator fixes for 2.6.33

Thanks

Liam

---

The following changes since commit 676ad585531e965416fd958747894541dabcec96:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../bp/bp

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Mark Brown (1):
      regulator: Fix display of null constraints for regulators

Roel Kluin (1):
      regulator/lp3971: vol_map out of bounds in lp3971_{ldo,dcdc}_set_voltage()

 drivers/regulator/core.c   |    2 +-
 drivers/regulator/lp3971.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


