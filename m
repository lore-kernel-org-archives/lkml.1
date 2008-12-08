Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbYLHPZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbYLHPZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 10:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbYLHPZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 10:25:32 -0500
Received: from citadel.icyb.net.ua ([212.40.38.140]:1961 "EHLO
	citadel.icyb.net.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbYLHPZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 10:25:31 -0500
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Dec 2008 10:25:30 EST
Message-ID: <493D3AAF.4030208@icyb.net.ua>
Date: Mon, 08 Dec 2008 17:18:07 +0200
From: Andriy Gapon <avg@icyb.net.ua>
User-Agent: Thunderbird 2.0.0.18 (X11/20081124)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: watchdog driver (iTCO_wdt) and intel dg33tl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[please cc me on reply, thank you]

I come from FreeBSD land and have a quick question.
Can anybody confirm if with Linux iTCO_wdt the watchdog can produce any
effect on DG33TL motherboard when its timer runs down?

With FreeBSD driver I get zero effect (after kill -9 for watchdogd
process), so I would like to find out if this is a driver issue or a
platform issue before diving into the code.

Thank you!

-- 
Andriy Gapon
