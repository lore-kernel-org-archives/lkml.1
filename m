Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbXKBGYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbXKBGYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 02:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXKBGY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 02:24:28 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:37232 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbXKBGY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 02:24:27 -0400
X-IronPort-AV: i="4.21,361,1188792000"; 
   d="scan'208"; a="42907910:sNHT21441840"
From: Bryan Wu <bryan.wu@analog.com>
To: khali@linux-fr.org, i2c@lm-sensors.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Blackfin I2C/TWI driver updates and bug fixing according to Jean's review
Date: Fri,  2 Nov 2007 14:24:20 +0800
Message-Id: <1193984664-10609-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Still remain in old I2C driver interface. I plan to move to new style I2C API recently.
Also intend to using new TWI register accessor functions as Jean's suggestions.
Then move that static pin_req setting to our Blackfin board files.

But currently version is OK and tested on Blackfin board with I2C devices.

