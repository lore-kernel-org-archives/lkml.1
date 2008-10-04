Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbYJDJpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbYJDJpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 05:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYJDJpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 05:45:08 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:6162 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbYJDJpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 05:45:07 -0400
Date: Sat, 4 Oct 2008 11:44:57 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.27
Message-ID: <20081004114457.27a2fd70@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.27 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus

 drivers/hwmon/it87.c        |   70 +++++++++++++++++++++++++++++++-----------
 drivers/misc/eeepc-laptop.c |   16 ++++++++--
 2 files changed, 64 insertions(+), 22 deletions(-)

---------------

Corentin Chary (1):
      eeepc-laptop: Fix hwmon interface

Jean Delvare (1):
      hwmon: (it87) Prevent power-off on Shuttle SN68PT

Thanks,
-- 
Jean Delvare
