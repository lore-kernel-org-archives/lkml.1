Return-Path: <linux-kernel-owner+w=401wt.eu-S937851AbXHLVkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937851AbXHLVkq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 17:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761607AbXHLVkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 17:40:36 -0400
Received: from alnrmhc13.comcast.net ([204.127.225.93]:38174 "EHLO
	alnrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462AbXHLVkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 17:40:35 -0400
Subject: Kernel 2.6.23-rc2 git4 & git5
From: Chris Holvenstot <cholvenstot@comcast.net>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 12 Aug 2007 16:42:42 -0500
Message-Id: <1186954962.8166.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This morning I reported an issue which cause a failure of the
2.6.23-rc2-git4 kernel to boot on my system.  The contents of my post
may be viewed here:

http://www.ussg.iu.edu/hypermail/linux/kernel/0708.1/1959.html

After 3 separate builds from "virgin sources" I still had the boot
failure with the git4 level kernel.

This afternoon I picked up the git5 patch and it comes up and appears to
run without problem.

Same base system.  Same hardware.  Same build process.

So even though I have only been building and running "pre-release"
kernels for a short time I feel confident in saying that something was
not kosher with the git4 patch - at least when it came to my system.

(system configuration data is in the original post)

I would not normally burn the valuable time of others with a rhetorical
post but I looked at the changes out into the git5 patch and did not
spot anything that looked like it would have resolved the issue I was
having and I hate not being  able to correlate a cause and effect here.

Any clues, or did I just get lucky with this one?





