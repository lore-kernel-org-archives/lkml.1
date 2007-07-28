Return-Path: <linux-kernel-owner+w=401wt.eu-S965339AbXG1Inj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965339AbXG1Inj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 04:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbXG1In2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 04:43:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51411 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbXG1In1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 04:43:27 -0400
X-Greylist: delayed 35685 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jul 2007 04:43:27 EDT
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46AB0185.3020405@s5r6.in-berlin.de>
Date: Sat, 28 Jul 2007 10:42:45 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       david@lang.hm, Andrew Morton <akpm@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [2.6 patch] let SUSPEND select HOTPLUG_CPU
References: <200707251238.50218.lenb@kernel.org> <200707262117.26353.rjw@sisk.pl> <alpine.LFD.0.999.0707261255380.3442@woody.linux-foundation.org> <200707262248.09187.rjw@sisk.pl> <alpine.LFD.0.999.0707261351430.3442@woody.linux-foundation.org> <20070727222503.GB15129@stusta.de> <46AA7609.1040900@s5r6.in-berlin.de> <20070727230307.GC15129@stusta.de>
In-Reply-To: <20070727230307.GC15129@stusta.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Jul 28, 2007 at 12:47:37AM +0200, Stefan Richter wrote:
>> Yes, that's the price to pay if you want to select something that in
>> turn depends on a number of other things.
> 
> Yes, but a good user interface is worth it.

That's right.  But a hypothetical other way would be to leave Kconfigs
minimal ands put the necessary features into scripts/kconfig.
-- 
Stefan -ENOPATCH Richter
-=====-=-=== -=== ===--
http://arcgraph.de/sr/
