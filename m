Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYDWVVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYDWVVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbYDWVV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:21:26 -0400
Received: from service2.sh.cvut.cz ([147.32.127.218]:52471 "EHLO
	service2.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYDWVV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:21:26 -0400
Message-ID: <480FA8A4.7020207@seznam.cz>
Date: Wed, 23 Apr 2008 23:22:44 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: Arnd Bergmann <arnd@arndb.de>, Paul Mackerras <paulus@samba.org>,
       benh@kernel.crashing.org,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       John Linn <John.Linn@xilinx.com>, git-dev@xilinx.com,
       Grant Likely <grant.likely@secretlab.ca>, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: Microblaze Linux release
References: <48020A21.4000404@seznam.cz> <200804161733.04714.arnd@arndb.de> <480FA235.8000203@seznam.cz> <200804232257.04060.florian.fainelli@telecomint.eu>
In-Reply-To: <200804232257.04060.florian.fainelli@telecomint.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Michal
> 
>> Hi all,
>>
>> I update Microblaze kernel to latest Linus tree. I fixed some problems
>> which come with it.
> 
> While reading the previous discussion, I wondered that keeping PCI would be a 
> good idea. I am personnaly using it for a custom design and would be glad 
> being able to continue using it.

I'll add PCI parts as I will have a reason to do it. I have no PCI devices
connected to MB now.

> If this represents too much work for you, we can probably add it later.

yes. This is lot of work for me unfortunately without any commercial support.

> Great work !

Have a good day,
Michal Simek
