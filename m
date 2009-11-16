Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbZKPTXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbZKPTXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 14:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZKPTXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 14:23:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:57292 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbZKPTXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 14:23:12 -0500
Subject: [GIT PULL] regulator fixes for 2.6.32
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Nov 2009 19:23:07 +0000
Message-ID: <1258399387.3570.168.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following regulator fixes for 2.6.32.

Thanks

Liam 

---

The following changes since commit a9366e61b03f55a6e009e687ad10e706714c9907:
  Linus Torvalds (1):
        Merge git://git.infradead.org/users/dwmw2/iommu-2.6.32

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Dan Carpenter (1):
      dereferencing freed memory regulator_fixed_voltage_remove()

Mark Brown (1):
      regulator: Handle missing constraints in _regulator_disable()

Roel Kluin (1):
      regulator: Fix check of unsigned return value and transmit errors in wm831x_gp_ldo_get_mode()

 drivers/regulator/core.c       |    3 ++-
 drivers/regulator/fixed.c      |    5 ++---
 drivers/regulator/wm831x-ldo.c |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)


