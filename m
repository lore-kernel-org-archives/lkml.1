Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZGKM0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZGKM0a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 08:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZGKM0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 08:26:20 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:12837 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbZGKM0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 08:26:20 -0400
Date: Sat, 11 Jul 2009 14:26:10 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.31
Message-ID: <20090711142610.048b69f5@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some hwmon subsystem fixes for Linux 2.6.31 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

 drivers/hwmon/abituguru3.c |    6 +++---
 drivers/hwmon/max6650.c    |    1 +
 drivers/hwmon/sht15.c      |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

---------------

Alistair John Strachan (1):
      hwmon: (abituguru3) DMI probing for AB9, AB9 QuadQT and IX38 QuadGT

Jiri Slaby (1):
      hwmon: (max6650) Fix lock imbalance

Joe Perches (1):
      hwmon: (sht15) Remove unnecessary semicolon

Thanks,
-- 
Jean Delvare
