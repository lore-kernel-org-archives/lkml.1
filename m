Return-Path: <linux-kernel-owner+w=401wt.eu-S1031522AbXD1LiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031522AbXD1LiN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 07:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031523AbXD1LiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 07:38:12 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54157 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031522AbXD1LiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 07:38:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46333211.6030506@s5r6.in-berlin.de>
Date: Sat, 28 Apr 2007 13:37:53 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: linux1394-devel@lists.sourceforge.net, Ben Collins <bcollins@debian.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/30] Use menuconfig objects - IEEE1394
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704102316160.32056@yvahk01.tjqt.qr> <4632638D.2050004@s5r6.in-berlin.de> <Pine.LNX.4.61.0704280944100.506@yvahk01.tjqt.qr> <463324CD.1010604@s5r6.in-berlin.de> <Pine.LNX.4.61.0704281254280.506@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704281254280.506@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Apr 28 2007 12:41, Stefan Richter wrote:
>> So, shall I put Jan's patch aside until there is only one stack left?
> 
> Sort of.
[...]
> when a menu has
> two or three choices (in this case: larger subsystems), it's rand()
> for me whether or not to convert to menuconfig.
> Feel free.

I'll see if anybody out there will voice an opinion, to tip the balance
one way or another.
-- 
Stefan Richter
-=====-=-=== -=-- ===--
http://arcgraph.de/sr/
