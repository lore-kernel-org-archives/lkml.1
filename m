Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbXJKKQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbXJKKQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbXJKKQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:16:17 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:29388 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbXJKKQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:16:16 -0400
X-IronPort-AV: i="4.21,259,1188792000"; 
   d="scan'208"; a="53762824:sNHT20884717"
From: Bryan Wu <bryan.wu@analog.com>
To: khali@linux-fr.org, i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 0/2] Blackfin I2C TWI driver updates for 2.6.24
Date: Thu, 11 Oct 2007 18:16:09 +0800
Message-Id: <1192097771-25417-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


 - BF54x multiport supports
 - bug fixing
