Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab0AOPWS (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 10:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364Ab0AOPWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 10:22:17 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:47713 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab0AOPWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 10:22:16 -0500
Date: Fri, 15 Jan 2010 16:22:15 +0100
To: ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: hang on 2.6.33-rc4
Message-ID: <20100115152215.GC2541@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

kernel 2.6.33-rc4

I am having repeatable complete hard lockups on my laptop with 2.6.33-rc4.
2.6.32.3 works fine.

I believe that it is related to the network, because sometimes I can
actually log in (gnomes session) and as soon as I do some network
related suddenly hard hang, not even Sysrq working anymore.

Interestingly it only happens at a specific AP where the ESSID is
hidden (at work). At home I can work without any problems (ESSID not
hidden).

Unfortunately I cannot set up a serial console or similar.

Is there still anything else I can provide you for tracking that down.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan            TU Wien, Austria           Debian TeX Task Force
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
POGES (pl.n.)
The lumps of dry powder that remain after cooking a packet soup.
			--- Douglas Adams, The Meaning of Liff
