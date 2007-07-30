Return-Path: <linux-kernel-owner+w=401wt.eu-S939831AbXG3VHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939831AbXG3VHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939145AbXG3VHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:07:06 -0400
Received: from compulypse.net ([212.227.20.180]:14146 "EHLO compulypse.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938813AbXG3VHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:07:05 -0400
X-Greylist: delayed 2479 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 17:07:04 EDT
Subject: Linux Kernel cfs scheduler and xorg kbd
From: "<::.. Teresa_II ..::>" <teresa@kvitka.net>
To: CK Mailinglist <ck@vds.kolivas.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 22:25:30 +0200
Message-Id: <1185827130.26459.16.camel@xtower.fri>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,


first of all i am not sure if its scheduler issue. But i didn't found
anything about that in google related to something else.

So i tried 2.6.22.1 kernel with new cfs scheduler v19.1 from Ingo page.
Previous i used 2.6.22-ck1.

After 24 hours running i get strange behavior in Xorg. It act slower
with my special keys, like SHIFT, or CTRL. So if i hold SHIFT and press
")" and than will press enter, i release SHIIFT and press ENTER it
doesn't create new line. Even if i start write a Sentence or word with
"SHIFTed" char it makes next char in high case also. 
Like this: "HAllo" even if i type "Hallo".

It's extremely unusable.

It doesn't happen if i am on other kernel.

I am ready to provide any requested information to find issue.
If its not kernel related thing - i am very sorry, i just don't know
where to start to trace whats wrong.

I am on gentoo and use latest xorg server. Keyboard driver is "KBD".
Mouse use "evdev" driver.

-- 
Teresa Kalitowska
jid: teresa@kvitka.net

