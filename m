Return-Path: <linux-kernel-owner+w=401wt.eu-S1762314AbYBGXuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762314AbYBGXuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbYBGXts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:49:48 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41895 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755375AbYBGXtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:49:47 -0500
X-Sasl-enc: e5D0ECImHc86EjyEbw2kiI2cDfDrFv677NrntvvRbEWf 1202428182
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
       linux-acpi@vger.kernel.org
Subject: [RFC] LED brightness_get and thinkpad-acpi led-class support
Date: Thu,  7 Feb 2008 21:49:05 -0200
Message-Id: <1202428145-6106-1-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Richard,

Would you accept the addition of brightness_get to the led class?  Please
look at the first patch in this small patch set series.  I need it for
thinkpad-acpi...

The other two patches to thinkpad-acpi are included for reference on how I
intend to useg the new brightness_get stuff, and also the hardware
acceleration for led flashing.  While the thinkpad-acpi patches do work, it
is unlikely to apply cleanly since it is from the tip of my thinkpad-acpi
development tree :) They are NOT to be merged right now, I will submit them
to Len Brown later, for 2.6.26.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
