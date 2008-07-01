Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbYGAVEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbYGAVEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbYGAVEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:04:43 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:26614 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbYGAVEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:04:42 -0400
Date: Tue, 1 Jul 2008 23:03:54 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [GIT PULL] i2c documentation updates for 2.6.26
Message-ID: <20080701230354.4dcce346@hyperion.delvare>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the i2c subsystem documentation updates for Linux 2.6.26
from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

(Note to other readers: please do NOT pull the whole kernel tree from
this location, my line wouldn't like it.)


 Documentation/i2c/writing-clients |   18 ++++++++++++++----
 include/linux/i2c.h               |    2 +-
 2 files changed, 15 insertions(+), 5 deletions(-)

---------------

Ben Dooks (1):
      i2c: Documentation: fix device matching description

Wolfram Sang (1):
      i2c: Fix bad hint about irqs in i2c.h

Thanks,
-- 
Jean Delvare
