Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYJ3PBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYJ3PBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbYJ3PBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:01:00 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:28125 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbYJ3PBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:01:00 -0400
Date: Thu, 30 Oct 2008 16:00:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.28
Message-ID: <20081030160051.1265df84@hyperion.delvare>
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
 Documentation/i2c/busses/i2c-sis96x |    2 +-
 MAINTAINERS                         |   20 ++++++++++----------
 drivers/i2c/busses/i2c-s3c2410.c    |    2 +-
 drivers/i2c/busses/scx200_i2c.c     |    1 +
 4 files changed, 13 insertions(+), 12 deletions(-)

---------------

Jean Delvare (1):
      i2c: The i2c mailing list is moving

Julia Lawall (1):
      i2c-s3c2410: Correct use of ! and &

Lennart Sorensen (1):
      scx200_i2c: Add missing class parameter

Thanks,
-- 
Jean Delvare
