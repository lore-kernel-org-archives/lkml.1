Return-Path: <linux-kernel-owner+w=401wt.eu-S967473AbXEHNEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967473AbXEHNEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967206AbXEHNEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:04:10 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:57654 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967391AbXEHNEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:04:08 -0400
Message-ID: <4640750B.4040801@s5r6.in-berlin.de>
Date: Tue, 08 May 2007 15:03:07 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Create a top-level "Space-critical features" menu.
References: <Pine.LNX.4.64.0705080356020.10881@localhost.localdomain> <1178612519.3042.294.camel@localhost.localdomain> <Pine.LNX.4.64.0705080431110.13403@localhost.localdomain> <Pine.LNX.4.61.0705081117051.17280@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705081117051.17280@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On May 8 2007 04:41, Robert P. J. Day wrote:
>>  in my opinion, the config option "EMBEDDED" is just plain silly.  as
>>i mentioned earlier, there may be other reasons that people want to
>>de-activate normally selected features rather than just for strictly
>>embedded systems.
> 
> Did not you want to make a patch row that expresses all your ideas, aka
>   CONFIG_EXPERT
>   CONFIG_ASKFORDETAILS (former CONFIG_EMBEDDED, e.g. "place in memory where
> kernel is loaded")

Some of this might be better left to GUIs or HOWTOs.

>   CONFIG_OBSOLETE
>   CONFIG_DEPRECATED
> etc.? :)
> 
> 
> 
> Jan


-- 
Stefan Richter
-=====-=-=== -=-= -=---
http://arcgraph.de/sr/
