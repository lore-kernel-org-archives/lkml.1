Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbXENRdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbXENRdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbXENRdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:33:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33001 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757604AbXENRdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:33:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46489D48.2040405@s5r6.in-berlin.de>
Date: Mon, 14 May 2007 19:32:56 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Tilman Schmidt <tilman@imap.cc>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org> <4647569D.7010709@imap.cc> <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On May 13 2007 20:19, Tilman Schmidt wrote:
...
>> Ethernet (1000 Mbit) (NETDEV_1000) [Y/n] (NEW)
>> Ethernet (10000 Mbit) (NETDEV_10000) [Y/n] (NEW)
>>
>> Those for the latter three could/should say something like the
>> one for the WLAN_80211 option.
> 
> "Patches welcome" ;-)
> 
> As for NETDEV_1000 and _10000, I really wonder if we need anymore
> help text than the option. I do not know what the minimum level
> of user knowledge is that kconfig help texts need to support,
> but maybe you can tell?

The text "Ethernet (10000 Mbit)" _doesn't_ tell me that this option
"does not affect the kernel build, it only lets [me] choose drivers".

The "patches welcome" is quite appropriate.  On the other hand, visible
Kconfig options without help text should almost never be allowed to go
in in the first place, IMO.
-- 
Stefan Richter
-=====-=-=== -=-= -===-
http://arcgraph.de/sr/
