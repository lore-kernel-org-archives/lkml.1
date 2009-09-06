Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbZIFVQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbZIFVQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 17:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758919AbZIFVQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 17:16:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49132 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758918AbZIFVPr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 17:15:47 -0400
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Janos Laube" <janos.dev@gmail.com>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera>
In-Reply-To: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera>
From: "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <hKF51Pczj6N.A.-nH.V3BpKB@chimera>
Subject: [Bug #14049] joydev: blacklist digitizers avoids recognition of Saitek X52 joysticks
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun,  6 Sep 2009 20:11:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This message has been generated automatically as a part of a report
of regressions introduced between 2.6.29 and 2.6.30.

The following bug entry is on the current list of known regressions
introduced between 2.6.29 and 2.6.30.  Please verify if it still should
be listed and let me know (either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14049
Subject		: joydev: blacklist digitizers avoids recognition of Saitek X52 joysticks
Submitter	: Janos Laube <janos.dev@gmail.com>
Date		: 2009-08-24 14:18 (14 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d07a9cba6be5c0e947afc1014b5a62182a86f1f1


