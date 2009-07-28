Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbZG1Quc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbZG1Quc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbZG1Qub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:50:31 -0400
Received: from bamako.nerim.net ([62.4.17.28]:54008 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZG1Qua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:50:30 -0400
Date: Tue, 28 Jul 2009 18:50:25 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fix for 2.6.31
Message-ID: <20090728185025.4f437bc7@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull one i2c subsystem fix for Linux 2.6.31 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

 drivers/i2c/chips/tsl2550.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

---------------

Michele Jr De Candia (1):
      i2c/tsl2550: Fix lux value in dark environment

Thanks,
-- 
Jean Delvare
