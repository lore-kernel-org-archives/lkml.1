Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYHYJNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYHYJNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 05:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbYHYJNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 05:13:32 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:13209 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbYHYJNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 05:13:31 -0400
X-IronPort-AV: E=Sophos;i="4.32,264,1217822400"; 
   d="scan'208";a="58495741"
From: Bryan Wu <cooloney@kernel.org>
To: felipe.balbi@nokia.com, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] usb: musb bug fixing patches
Date: Mon, 25 Aug 2008 17:13:39 +0800
Message-Id: <1219655621-18510-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Felipe,

I found some MUSB bugs on Blackfin, here are 2 patches to fix them.

Thanks
-Bryan
