Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbYBPPZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbYBPPZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 10:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbYBPPY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 10:24:57 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35687 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbYBPPY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 10:24:56 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 16 Feb 2008 16:24:43 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: New branch in linux1394-2.6.git for -mm
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <tkrat.0de17d6cc3ff38b3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

please switch your scripts from linux1394-2.6.git:master to
linux1394-2.6.git:for-mm for firewire and ieee1394 updates from now on.
I.e. the URL to pull from becomes

    master.kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-mm
or
    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-mm

This will allow me to differentiate between master for other firewire
developers, for-next for Stephen's new linux-next tree, and for-mm for
the weird stuff. ;-)

Thanks,
-- 
Stefan Richter
-=====-==--- --=- =----
http://arcgraph.de/sr/

