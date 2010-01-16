Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab0APA6S (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 19:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412Ab0APA6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 19:58:17 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53306 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758392Ab0APA6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 19:58:16 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B510EFE.50201@s5r6.in-berlin.de>
Date: Sat, 16 Jan 2010 01:57:34 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 (changelog update only)] scripts/get_maintainer.pl:
 Add --sections, print entire matched subsystem
References: <1263408063.8011.116.camel@Joe-Laptop.home>	 <20100114151254.72b57501.akpm@linux-foundation.org>	 <1263519770.1903.49.camel@Joe-Laptop.home>	 <4B507B73.6000404@s5r6.in-berlin.de> <1263602598.15135.30.camel@Joe-Laptop.home>
In-Reply-To: <1263602598.15135.30.camel@Joe-Laptop.home>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Fri, 2010-01-15 at 15:28 +0100, Stefan Richter wrote:
>> USB SMSC95XX ETHERNET DRIVER
>>     M:Steve Glendinning <steve.glendinning@smsc.com>
>>     L:netdev@vger.kernel.org
[...]
> The MAINTAINERS file uses tab or space after "^[A-Z]:"
> Perhaps that format should be kept.

Right, the original format is actually better (if you want to tweak your
output at all).
-- 
Stefan Richter
-=====-==-=- ---= =----
http://arcgraph.de/sr/
