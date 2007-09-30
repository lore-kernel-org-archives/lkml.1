Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbXI3Qpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbXI3Qpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 12:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbXI3Qpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 12:45:36 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49115 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757994AbXI3Qpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 12:45:35 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46FFD286.5060209@s5r6.in-berlin.de>
Date: Sun, 30 Sep 2007 18:44:54 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       linux1394-devel@lists.sourceforge.net,
       Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [1/3] 2.6.23-rc6: known regressions v2 --- ieee1394, empty suspend
 stopped working
References: <46EB436E.6030509@googlemail.com> <46ECF8C8.5040308@s5r6.in-berlin.de> <200709161409.14908.rjw@sisk.pl>
In-Reply-To: <200709161409.14908.rjw@sisk.pl>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote on 2007-09-16:
[me having trouble to set something up to reproduce the regression]
> Can you please try "echo test > /sys/power/disk" before the hibernation?
> 
> After that "echo disk > /sys/power/state" should only "suspend" the box
> for several seconds and come back to the command prompt.
> 
> If that fails, please try
> 
> # echo testproc > /sys/power/disk
> # echo disk > /sys/power/state
> 
> and see if this returns to the command prompt.

Sorry for keeping silence, but there is too much else going on here at
the moment.  If I find time to follow up reasonably soon, I'll do.
Thanks for the advice.
-- 
Stefan Richter
-=====-=-=== =--= ====-
http://arcgraph.de/sr/
