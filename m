Return-Path: <linux-kernel-owner+w=401wt.eu-S1030729AbXDJWli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030729AbXDJWli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030731AbXDJWli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:41:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33528 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030729AbXDJWlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:41:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <461C1292.2040509@s5r6.in-berlin.de>
Date: Wed, 11 Apr 2007 00:41:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: David Lang <david.lang@digitalinsight.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/30] Use menuconfig objects
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr> <461C09D6.40805@s5r6.in-berlin.de> <Pine.LNX.4.63.0704101437470.27318@qynat.qvtvafvgr.pbz>
In-Reply-To: <Pine.LNX.4.63.0704101437470.27318@qynat.qvtvafvgr.pbz>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Lang wrote:
> On Wed, 11 Apr 2007, Stefan Richter wrote:
>>  - with make xconfig: OK
>>  - with make gconfig: OK
>>  - with make menuconfig: less so, because:
>> When one switches a menuconfig _on_, one might miss that there are
>> subsequent options to configure.  (Although the availability of further
>> options is indicated by the '--->' suffix to the menu title.)
> 
> I use menuconfig almost excludively, there are already quite a few cases
> where the menuconfig is used, so you already need to watch out for the
> '--->' when you turn it on.

OK.

> I haven't applied this patch series, but I definantly like the concept.
> I spend a _lot_ of time with a new kernel going through and entering
> menus for the sole purpose of disabling everything in them, being able
> to do so from the level above would be nice.
...

Actually, people who configure a kernel less than twice a year should be
first heard on these matters. :-) You won't find many of those people
here on LKML though.
-- 
Stefan Richter
-=====-=-=== -=-- -=-==
http://arcgraph.de/sr/
