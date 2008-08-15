Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbYHOIO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbYHOIO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 04:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYHOIOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 04:14:15 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:10324 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbYHOIOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:14:14 -0400
X-IronPort-AV: E=Sophos;i="4.32,214,1217822400"; 
   d="scan'208";a="58085698"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Blackfin serial driver bug fixing
Date: Fri, 15 Aug 2008 16:14:07 +0800
Message-Id: <1218788049-7632-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Alan,

Here is 2 critical bug fixing patch for Blackfin serial driver.
And as you acked the previous 8 Blackfin serial driver patches, need I
push them to blackfin-2.6 git tree and ask Linus to pull from that or
they were queued in your serial tree?

Thanks,
-Bryan
