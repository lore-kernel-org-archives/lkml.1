Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbZIFRCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbZIFRCI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 13:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758056AbZIFRCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 13:02:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48207 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758054AbZIFRCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 13:02:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Zaurus suspend saga
Date: Sun, 6 Sep 2009 19:03:10 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc8-rjw; KDE/4.3.1; x86_64; ; )
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       "linux-arm-kernel" <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       utx@penguin.cz
References: <20090906052653.GB1324@ucw.cz>
In-Reply-To: <20090906052653.GB1324@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909061903.10542.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 September 2009, Pavel Machek wrote:
> Hi!
> 
> Even with mtd regression fixed, spitz will still not suspend/resume
> correctly.

Is the regression fixed in the Linus' tree, or do you still need to apply the
revert patch?

Rafael
