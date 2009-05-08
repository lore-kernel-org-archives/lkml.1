Return-Path: <linux-kernel-owner+w=401wt.eu-S1763798AbZEHTAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763798AbZEHTAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbZEHTAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:00:22 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:47689 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbZEHTAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:00:21 -0400
Date: Fri, 8 May 2009 20:59:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] hwmon fixes for 2.6.30
Message-ID: <20090508205916.4478b06c@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some hwmon subsystem fixes for Linux 2.6.30 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus

 drivers/hwmon/asus_atk0110.c |    2 ++
 drivers/hwmon/w83781d.c      |    3 ++-
 2 files changed, 4 insertions(+), 1 deletions(-)

---------------

Jean Delvare (1):
      hwmon: (w83781d) Fix W83782D support (NULL pointer dereference)

Luca Tettamanti (1):
      hwmon: (asus_atk0110) Fix compiler warning

Thanks,
-- 
Jean Delvare
