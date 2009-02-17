Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZBQTC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZBQTC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZBQTCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:02:16 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:27971 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZBQTCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:02:16 -0500
Date: Tue, 17 Feb 2009 20:02:00 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.29
Message-ID: <20090217200200.3b9ce3ea@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some hwmon subsystem fixes for Linux 2.6.29 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus

 MAINTAINERS               |    8 ++++----
 drivers/hwmon/f71882fg.c  |    4 ++--
 drivers/hwmon/vt1211.c    |    2 +-
 drivers/hwmon/w83627ehf.c |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

---------------

Frank Seidel (1):
      MAINTAINERS: Switch hdaps to Frank Seidel

Hans de Goede (1):
      hwmon: Fix ACPI resource check error handling

Jean Delvare (1):
      hwmon: (f71882fg) Hide misleading error message

-- 
Jean Delvare
