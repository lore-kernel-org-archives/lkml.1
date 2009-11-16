Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbZKPNVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbZKPNVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 08:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZKPNVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 08:21:44 -0500
Received: from bamako.nerim.net ([62.4.17.28]:60208 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbZKPNVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 08:21:44 -0500
Date: Mon, 16 Nov 2009 14:21:46 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.32
Message-ID: <20091116142146.6b0a9841@hyperion.delvare>
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

 drivers/hwmon/adt7475.c   |   17 ++++++++---------
 drivers/hwmon/s3c-hwmon.c |   11 +++++++++--
 2 files changed, 17 insertions(+), 11 deletions(-)

---------------

Ben Dooks (1):
      hwmon: (s3c-hwmon) Ignore invalid divider settings

Jean Delvare (3):
      hwmon: (adt7475) Fix temperature fault flags
      hwmon: (adt7475) Cache limits for 60 seconds
      hwmon: (adt7475) Fix sysfs file names

Thanks,
-- 
Jean Delvare
