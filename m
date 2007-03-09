Return-Path: <linux-kernel-owner+w=401wt.eu-S1767300AbXCIOGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767300AbXCIOGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 09:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767299AbXCIOGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 09:06:15 -0500
Received: from smtp.nokia.com ([131.228.20.173]:45593 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767300AbXCIOGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 09:06:14 -0500
Message-ID: <45F169CA.3000106@yandex.ru>
Date: Fri, 09 Mar 2007 16:06:02 +0200
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: the usage of DEBUG_DRIVER seems ambiguous
References: <Pine.LNX.4.64.0703071941200.14336@CPE00045a9c397f-CM001225dbafb6> <20070308111858.9352f51d.randy.dunlap@oracle.com>
In-Reply-To: <20070308111858.9352f51d.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Mar 2007 14:06:03.0246 (UTC) FILETIME=[129DE0E0:01C76254]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
>>   it's clearly a configuration variable, but it's also being used by
>> itself in a few drivers/net/ source files.  is that deliberate?
> 
> The ones in drivers/net/ are just local driver debug controls.
> They happen to have the same name as a (likely newer) kconfig symbol.
> 
> Is there a real problem that needs to be fixed?

Renaming them just for the sake of being less confusing makes sense.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
