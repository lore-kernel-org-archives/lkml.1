Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345AbXD2DWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345AbXD2DWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 23:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbXD2DWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 23:22:31 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:34270 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbXD2DWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 23:22:30 -0400
X-IronPort-AV: i="4.14,465,1170651600"; 
   d="scan'208"; a="36822430:sNHT20016304"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/7] blackfin arch and driver patches update against 2.6.21-rc7-mm2
Date: Sun, 29 Apr 2007 11:23:06 +0800
Message-Id: <11778169933996-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Some bugfixes in blackfin arch patch, serial core patch
* Update blackfin spi controller driver patch accoding to David Brownell's review
