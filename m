Return-Path: <linux-kernel-owner+w=401wt.eu-S964785AbXDKSyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785AbXDKSyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964793AbXDKSyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:54:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47337 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964785AbXDKSyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:54:41 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <461D2EC0.6010101@s5r6.in-berlin.de>
Date: Wed, 11 Apr 2007 20:53:52 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Eberhard_M=F6nkeberg?= <emoenke@gwdg.de>
Subject: Re: [PATCH 24/30] Use menuconfig objects - oldcd
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>	<Pine.LNX.4.61.0704102336550.32056@yvahk01.tjqt.qr>	<Pine.LNX.4.61.0704110952390.32056@yvahk01.tjqt.qr> <20070411011244.35b8e5a5.akpm@linux-foundation.org>
In-Reply-To: <20070411011244.35b8e5a5.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 11 Apr 2007 09:55:49 +0200 (MEST) Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>> Any hints who should get it, or would you take care of it?
> 
> Send it to me.  Send everything to me, if you actually want it applied :(
> 
> I'll get this stuff off lkml, when I get that far.

I can handle part 13/30 IEEE1394 for you if I get told that it's good to
go upstream.

drivers/ieee1394/Kconfig in -mm will continue to differ from the one in
Linus' tree for quite a while.  You won't have fun with it.
-- 
Stefan Richter
-=====-=-=== -=-- -=-==
http://arcgraph.de/sr/
