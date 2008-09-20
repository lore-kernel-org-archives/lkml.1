Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbYITIbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbYITIbk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 04:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYITIbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 04:31:32 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:24537 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYITIbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 04:31:31 -0400
Date: Sat, 20 Sep 2008 10:31:11 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] hwmon fixes for 2.6.27
Message-ID: <20080920103111.2f0f512b@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.27 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus


 drivers/hwmon/ad7414.c |    2 +-
 drivers/hwmon/atxp1.c  |   18 +++++++++---------
 drivers/hwmon/it87.c   |    4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

---------------

Adrian Bunk (1):
      hwmon: (ad7414) Make ad7414_update_device() static

Andrew Paprocki (1):
      hwmon: (it87) Fix fan tachometer reading in IT8712F rev 0x7 (I)

Jean Delvare (1):
      hwmon: (atxp1) Fix device detection logic

Thanks,
-- 
Jean Delvare
