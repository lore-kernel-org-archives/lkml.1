Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbYLKLOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbYLKLOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 06:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbYLKLN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 06:13:58 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:16859 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbYLKLN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 06:13:57 -0500
Date: Thu, 11 Dec 2008 12:13:49 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.28
Message-ID: <20081211121349.70acb47b@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the i2c subsystem fixes for Linux 2.6.28 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

 drivers/i2c/busses/i2c-highlander.c |    4 ++--
 drivers/i2c/busses/i2c-pmcmsp.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

---------------

Harvey Harrison (2):
      i2c-pmcmsp: Fix endianness misannotation
      i2c-highlander: Trivial endian casting fixes

Thanks,
-- 
Jean Delvare
