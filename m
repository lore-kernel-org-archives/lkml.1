Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZG1Qve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZG1Qve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZG1Qve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:51:34 -0400
Received: from bamako.nerim.net ([62.4.17.28]:49413 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbZG1Qvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:51:33 -0400
Date: Tue, 28 Jul 2009 18:51:32 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.31
Message-ID: <20090728185132.43bacebf@hyperion.delvare>
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

 drivers/hwmon/asus_atk0110.c |    6 +++++-
 drivers/hwmon/smsc47m1.c     |   11 +++++++++++
 2 files changed, 16 insertions(+), 1 deletions(-)

---------------

Jean Delvare (1):
      hwmon: (smsc47m1) Differentiate between LPC47M233 and LPC47M292

Luca Tettamanti (1):
      hwmon: (asus_atk0110) Fix upper limit readings

Thanks,
-- 
Jean Delvare
