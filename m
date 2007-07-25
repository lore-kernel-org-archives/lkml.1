Return-Path: <linux-kernel-owner+w=401wt.eu-S933224AbXGYQ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224AbXGYQ2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbXGYQ2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:28:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55557 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbXGYQ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:28:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46A779E1.603@s5r6.in-berlin.de>
Date: Wed, 25 Jul 2007 18:27:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Manuel Lauss <mano@roarinelk.homelinux.net>
CC: Andreas Micklei <andreas.micklei@ivistar.de>,
       Andreas Messer <andreas.messer@stud-mail.uni-wuerzburg.de>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [BUG] firewire: mass-storage i/o-problems
References: <200707222332.12270.andreas.messer@stud-mail.uni-wuerzburg.de> <46A3E973.6090701@s5r6.in-berlin.de> <20070723063741.GA32240@roarinelk.homelinux.net> <46A45B65.9000704@s5r6.in-berlin.de> <20070723084505.GB349@roarinelk.homelinux.net> <46A49244.9010402@s5r6.in-berlin.de> <20070723183336.GA3736@roarinelk.homelinux.net> <20070723184405.GB3736@roarinelk.homelinux.net> <46A6598B.5080004@s5r6.in-berlin.de> <20070725051208.GA13710@roarinelk.homelinux.net>
In-Reply-To: <20070725051208.GA13710@roarinelk.homelinux.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manuel Lauss wrote:
> I tried 2.6.23 in the meantime, it's *MUCH* harder to trigger; in fact
> I had to skip through movies for ~10 minutes to get the orb timeout.
> The disk was inaccessible for a few seconds then recovered fine.
> 
>> Could you (and everyone else who has repeated I/O errors with the new
>> drivers, but not with the old drivers) test the attached patches, one
>> patch at a time?  They apply to 2.6.22.
> 
> Will do.

There are a few firewire fixes in 2.6.23-rc1 relative to 2.6.22, but I
don't believe they've got something to do with this issue.  Hence it
would be practical to test the patches on 2.6.22, but if you prefer you
could also test them on 2.6.23-*.  Thanks,
-- 
Stefan Richter
-=====-=-=== -=== ==--=
http://arcgraph.de/sr/
