Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYKJDYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYKJDYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 22:24:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYKJDXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 22:23:53 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:32448 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbYKJDXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 22:23:53 -0500
X-IronPort-AV: E=Sophos;i="4.33,572,1220241600"; 
   d="scan'208";a="62305285"
From: Bryan Wu <cooloney@kernel.org>
To: felipe.balbi@nokia.com, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] usb/musb Blackfin updates
Date: Mon, 10 Nov 2008 11:25:11 +0800
Message-Id: <1226287515-27247-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Felipe,

I regenerated the "[PATCH 15/17] usb: musb: add Blackfin specific
configuration to MUSB" on top of your patches. It should be easy for
you to merge.

And in this patchset, some other small fixings are included as well as.

Thanks
-Bryan
