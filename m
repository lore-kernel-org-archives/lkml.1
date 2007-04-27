Return-Path: <linux-kernel-owner+w=401wt.eu-S1757165AbXD0Tgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbXD0Tgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757171AbXD0Tgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:36:47 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39543 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165AbXD0Tgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 15:36:46 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46325070.9040706@s5r6.in-berlin.de>
Date: Fri, 27 Apr 2007 21:35:12 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>	<20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de>	<alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>	<20070426165950.GO3468@stusta.de> <m3d51rhtid.fsf@maximus.localdomain> <46322F63.9000604@msgid.tls.msk.ru>
In-Reply-To: <46322F63.9000604@msgid.tls.msk.ru>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
[...]
> there will be just no stable
> kernels *at all*. because when the next 2.6.x will start looking
> more or less useful due to 2.6.x.y series, there will be new 2.6.x+1,
> and work with 2.6.x stops...
> 
> It's not the case currently, but this way ("let's fix the bugs
> in 2.6.x.y -stable series, don't bother releasing 2.6.x in a good
> shape"), we can finally come to the above situation...

Actually, bugs are fixed in --> 2.6.(x+1)-rc <--, and shortly thereafter
a small selection of the fixes are "backported" to 2.6.x.y and to
various distributor kernels.
-- 
Stefan Richter
-=====-=-=== -=-- ==-==
http://arcgraph.de/sr/
