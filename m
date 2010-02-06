Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab0BFPFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 10:05:21 -0500
Received: from poutre.nerim.net ([62.4.16.124]:61421 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab0BFPFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 10:05:19 -0500
Date: Sat, 6 Feb 2010 16:05:17 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] hwmon fixes for 2.6.33
Message-ID: <20100206160517.4cca2e89@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.33 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

 drivers/hwmon/adt7462.c |    2 +-
 drivers/hwmon/lm78.c    |   25 ++++++++++++-------------
 drivers/hwmon/w83781d.c |   26 +++++++++++++-------------
 3 files changed, 26 insertions(+), 27 deletions(-)

---------------

Jean Delvare (2):
      hwmon: (lm78) Request I/O ports individually for probing
      hwmon: (w83781d) Request I/O ports individually for probing

Ray Copeland (1):
      hwmon: (adt7462) Wrong ADT7462_VOLT_COUNT

Thanks,
-- 
Jean Delvare
