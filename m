Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbZKWJJE (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 23 Nov 2009 04:09:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756474AbZKWJJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:09:00 -0500
Received: from gw.wifiinternet.cz ([89.31.42.6]:49967 "EHLO monstr.eu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756215AbZKWJIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:08:34 -0500
X-Greylist: delayed 1579 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 04:08:12 EST
From: y@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: michal.simek@petalogix.com, wuzhangjin@gmail.com, mingo@elte.hu,
        rostedt@goodmis.org
Subject: Microblaze ftrace support
Date: Mon, 23 Nov 2009 09:41:18 +0100
Message-Id: <1258965683-21302-1-git-send-email-y>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I did ftrace support for Microblaze. I would like to ask you for review.
I don't expect too much troubles. The main thing is part of recordmcount.pl
- here could be a small problem because of MIPS patches.

It is based on latest Linus tree.

I have that patches in my tree and they are in next tree too. They will go through my tree.

Thanks,
Michal



