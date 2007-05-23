Return-Path: <linux-kernel-owner+w=401wt.eu-S1763213AbXEWLPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763213AbXEWLPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 07:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759381AbXEWLPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 07:15:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58303 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759241AbXEWLPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 07:15:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46542248.3090507@s5r6.in-berlin.de>
Date: Wed, 23 May 2007 13:15:20 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [GIT PULL] ieee1394 fixes post 2.6.22-rc2
References: <tkrat.1171a59b9de88f9c@s5r6.in-berlin.de> <tkrat.5299b7dd67007e8c@s5r6.in-berlin.de>
In-Reply-To: <tkrat.5299b7dd67007e8c@s5r6.in-berlin.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote on 2007-05-19:
> Linus, please pull from the for-linus branch at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus
> 
> to receive the following IEEE 1394 subsystem updates:
> 
>   - fix regression in 2.6.22-rc1:
>     raw1394 asynchronous transmit was broken
> 
>   - fix old bug in raw1394:
>     32bit compat code for 64bit kernels was broken and incomplete
> 
>   - fix old eth1394 bug:
>     packets were frequently dropped in transmit path
>     (This fixes only the most common type of failure, tlabel exhaustion.)
> 
>   - trivial sbp2 fix

Linus,

if you didn't pull already, please don't.  Rather wait for my next batch
of -rc fixes.  At the moment it looks as if I should postpone raw1394's
32bit compat fixes (or call them feature addition) until after the
release of 2.6.22 to ensure we get them right.

Thanks,
-- 
Stefan Richter
-=====-=-=== -=-= =-===
http://arcgraph.de/sr/
