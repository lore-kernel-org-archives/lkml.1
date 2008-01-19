Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbYASOfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbYASOfi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 09:35:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbYASOfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 09:35:30 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:42073 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbYASOf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 09:35:29 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: david-b@pacbell.net, tony@atomide.com
Subject: [PATCH 0/4] USB OTG Targeted Peripheral List changes
Date: Sat, 19 Jan 2008 16:37:21 +0200
Message-Id: <1200753446-9378-1-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.5.4.rc3.24.gb53139
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The following patches changes the behavior of otg tpl and makes it
more compliant to otg specs.

The 5th patch shouldn't be applied and is against musb driver which
you can find in linux-omap git tree. It's here just to show another
feature that could be done with otg tpl; make it come from platform_data.

Any comments are welcome.

Best regards,
Felipe Balbi
me@felipebalbi.com

