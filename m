Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbYCLPBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbYCLPBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 11:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYCLPBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 11:01:46 -0400
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:62669 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751464AbYCLPBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 11:01:46 -0400
Date: Wed, 12 Mar 2008 16:01:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.25
Message-ID: <20080312160142.7adce5cc@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the i2c subsystem fixes for Linux 2.6.25 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

 drivers/i2c/busses/i2c-amd756.c |    2 +-
 drivers/i2c/chips/Makefile      |    7 +++++++
 drivers/i2c/i2c-core.c          |    6 +++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

---------------

Adrian Bunk (1):
      i2c-amd756: Fix off-by-one

Hans Verkuil (1):
      i2c: Keep client->driver and client->dev.driver in sync

Jean Delvare (1):
      i2c: chips subdirectory is deprecated

Thanks,
-- 
Jean Delvare
