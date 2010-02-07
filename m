Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab0BGWqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 17:46:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55190 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409Ab0BGWq3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 17:46:29 -0500
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Luca Tettamanti" <kronos.it@gmail.com>
References: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
In-Reply-To: <4Ht3jFrT7uE.A.JI.-nzbLB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <445R0ey9hAI.A.4VB.YozbLB@chimera>
Subject: [Bug #15195] kernel BUG at include/net/netns/generic.h:41, pfkey_create+0x36/0x18b [af_key]
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  7 Feb 2010 23:28:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a summary report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.32.  Please verify if it still should be listed and let the tracking team
know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15195
Subject		: kernel BUG at include/net/netns/generic.h:41, pfkey_create+0x36/0x18b [af_key]
Submitter	: Luca Tettamanti <kronos.it@gmail.com>
Date		: 2010-01-30 13:23 (9 days old)
References	: http://marc.info/?l=linux-netdev&m=126485785004775&w=4
Handled-By	: Alexey Dobriyan <adobriyan@gmail.com>
Patch		: http://patchwork.kernel.org/patch/75891/


