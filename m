Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbXJ3JSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbXJ3JSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbXJ3JSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:18:11 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:40149 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbXJ3JSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:18:10 -0400
X-IronPort-AV: i="4.21,346,1188792000"; 
   d="scan'208"; a="42689497:sNHT20067621"
From: Bryan Wu <bryan.wu@analog.com>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] Blackfin on-chip SPI controller driver updates and bug-fixing
Date: Tue, 30 Oct 2007 17:17:51 +0800
Message-Id: <1193735885-8202-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 - BF54x supported
 - multi-port supported
 - bunch of bug fixing 

