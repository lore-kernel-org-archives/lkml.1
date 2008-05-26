Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbYEZRIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbYEZRIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 13:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYEZRId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 13:08:33 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:17556 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbYEZRIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 13:08:32 -0400
Date: Mon, 26 May 2008 19:08:47 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.26
Message-ID: <20080526190847.0574f747@hyperion.delvare>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the i2c subsystem fixes for Linux 2.6.26 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

(Note to other readers: please do NOT pull the whole kernel tree from
this location, my line wouldn't like it.)

 drivers/media/video/tuner-core.c |   20 +++++++-------------
 include/linux/mod_devicetable.h  |    3 ++-
 2 files changed, 9 insertions(+), 14 deletions(-)

---------------

Jiri Slaby (1):
      i2c: Align i2c_device_id

Michael Krufky (1):
      tuner: Do not alter i2c_client.name

Thanks,
-- 
Jean Delvare
