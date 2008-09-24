Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbYIXLmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbYIXLmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 07:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbYIXLl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 07:41:57 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:38026 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbYIXLl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 07:41:57 -0400
Date: Wed, 24 Sep 2008 13:42:26 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.27
Message-ID: <20080924134226.4a98666e@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the i2c subsystem fixes for Linux 2.6.27 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus


 MAINTAINERS                       |    4 ++--
 drivers/i2c/busses/i2c-powermac.c |    4 ++--
 drivers/i2c/i2c-dev.c             |    4 +++-
 3 files changed, 7 insertions(+), 5 deletions(-)

---------------

Jean Delvare (1):
      i2c: Fix mailing lists in two MAINTAINERS entries

Sven Wegener (1):
      i2c-dev: Return correct error code on class_create() failure

Uwe Kleine-König (1):
      i2c-powermac: Fix section for probe and remove functions

Thanks,
-- 
Jean Delvare
