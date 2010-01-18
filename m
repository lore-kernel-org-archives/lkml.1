Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947Ab0ARPU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0ARPU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922Ab0ARPUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:20:55 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47062 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab0ARPUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:20:54 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B547C1E.5030405@s5r6.in-berlin.de>
Date: Mon, 18 Jan 2010 16:19:58 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Randy Dunlap <rdunlap@xenotime.net>, Greg Kroah-Hartman <greg@kroah.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HOWTO: Updates on subsystem trees, patchwork, -next (vs.
 -mm)
References: <4B4F7304.5050401@s5r6.in-berlin.de> <Pine.LNX.4.30.1001141303230.3979-100000@mail.perches.com>            <tkrat.e8ba67441fb65247@s5r6.in-berlin.de> <25759.1263824779@localhost>
In-Reply-To: <25759.1263824779@localhost>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Thu, 14 Jan 2010 23:39:46 +0100, Stefan Richter said:
[...]
>> -2.6.x -mm kernel patches
[...]
> I'm not sure that nuking *all* reference to it is appropriate.
> 
> On the other hand, I think there's like 3 other guys besides myself that
> actually test -mm kernels, so maybe the best bet is to see if it makes it
> upstream via the -mm route. ;)

-mm had and still has other purposes than the one for which -next was
established.  There is mention of -mm in
Documentation/development-process/, but if desired, I could attempt a
brief explanation of -mm for HOWTO.
-- 
Stefan Richter
-=====-==-=- ---= =--=-
http://arcgraph.de/sr/
