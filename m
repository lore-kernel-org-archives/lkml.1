Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbXIFSrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbXIFSrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 14:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbXIFSrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 14:47:36 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:51921 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622AbXIFSrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 14:47:35 -0400
From: Daniel Exner <dex@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: linux-kernel@vger.kernel.org
Subject: Kernel Panic on 2.6.23-rc5
Date: Thu, 6 Sep 2007 20:44:54 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709062044.54626.dex@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;dex@dragonslave.de;1189104455;b09d6136;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm not really sure if this is a regression or if I simply hit a hardware 
problem.
After some time of work (mostly hours sometimes minutes) my system will freeze 
including Blinking LED's and unresponsiveness on SysRQ, but I finally got 
this using netconsole:

CPU 0: Machine Check Exception: 0000000000000004
Bank 4: b200000000070f0f
Kernel panic - not syncing: CPU context corrupt

I Also keep getting ext3 errors about reading or writing in wrong zones.
Will now have a - this means many - run of memtest.

-- 
Greetings
Daniel Exner
