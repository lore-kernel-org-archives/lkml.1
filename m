Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbXJKKK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbXJKKK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbXJKKKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:10:47 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:36228 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbXJKKKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:10:46 -0400
X-IronPort-AV: i="4.21,259,1188792000"; 
   d="scan'208"; a="41538976:sNHT21599886"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 00/09] Blackfin SPI driver updates for 2.6.24
Date: Thu, 11 Oct 2007 18:10:32 +0800
Message-Id: <1192097441-24962-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


 - add BF54x support
 - add multi SPI ports support
 - fixup some bugs
