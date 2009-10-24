Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbZJXLt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbZJXLt1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 07:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZJXLt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 07:49:26 -0400
Received: from poutre.nerim.net ([62.4.16.124]:58078 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbZJXLt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 07:49:26 -0400
Date: Sat, 24 Oct 2009 13:49:28 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] hwmon fixes for 2.6.32
Message-ID: <20091024134928.3a6d5d0a@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some hwmon subsystem fixes for Linux 2.6.32 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus


 MAINTAINERS             |    1 +
 drivers/hwmon/dme1737.c |   29 ++++++++++++++++++++++++-----
 drivers/hwmon/fschmd.c  |    2 +-
 drivers/hwmon/it87.c    |    5 ++---
 4 files changed, 28 insertions(+), 9 deletions(-)

---------------

Huaxu Wan (1):
      hwmon: (coretemp) Maintainer update

Jean Delvare (2):
      hwmon: (dme1737) No vid attributes for SCH311x
      hwmon: (it87) Fix VID reading on IT8718F/IT8720F

Roel Kluin (1):
      hwmon: (fschmd) Fix check on unsigned in watchdog_write()

Thanks,
-- 
Jean Delvare
