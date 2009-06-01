Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbZFAOi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbZFAOi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZFAOiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:38:20 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:31643 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZFAOiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:38:20 -0400
Date: Mon, 1 Jun 2009 16:37:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] hwmon fixes for 2.6.30
Message-ID: <20090601163759.0d125486@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some hwmon subsystem fixes for Linux 2.6.30 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

 Documentation/hwmon/sysfs-interface |    6 ++++++
 drivers/hwmon/lm78.c                |    2 +-
 2 files changed, 7 insertions(+), 1 deletions(-)

---------------

Christian Engelmayer (1):
      hwmon: Update documentation on fan_max

Mike Frysinger (1):
      hwmon: (lm78) Add missing __devexit_p()

Thanks,
-- 
Jean Delvare
