Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbXJ3Jdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbXJ3Jdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757696AbXJ3JdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:33:22 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:23474 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960AbXJ3JdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:33:22 -0400
X-IronPort-AV: i="4.21,346,1188792000"; 
   d="scan'208"; a="42690586:sNHT22179297"
From: Bryan Wu <bryan.wu@analog.com>
To: khali@linux-fr.org, i2c@lm-sensors.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Blackfin I2C/TWI driver updates
Date: Tue, 30 Oct 2007 17:33:15 +0800
Message-Id: <1193736797-9005-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 - add support for BF54x TWI0 and TWI1
 - add PIN MUX operation

