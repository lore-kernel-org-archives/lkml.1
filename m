Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbZJMJYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbZJMJYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbZJMJYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:24:33 -0400
Received: from host179-6-static.238-77-b.business.telecomitalia.it ([77.238.6.179]:55120
	"EHLO mail.navynet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434AbZJMJYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:24:30 -0400
Message-ID: <4AD44724.4040105@navynet.it>
Date: Tue, 13 Oct 2009 11:23:48 +0200
From: Massimo Cetra <mcetra@navynet.it>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Massimo Cetra <ctrixk@navynet.it>
CC: David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [Bug #14378] Problems with net/core/skbuff.c
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>	<r-4Wjt4coy.A.CwC.Wal0KB@chimera> <20091012.034224.64980795.davem@davemloft.net> <4AD44435.3050703@navynet.it>
In-Reply-To: <4AD44435.3050703@navynet.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-auth-from: mcetra@navynet.it
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Massimo Cetra ha scritto:
> David Miller ha scritto:
>> From: "Rafael J. Wysocki" <rjw@sisk.pl>
>> Date: Mon, 12 Oct 2009 00:22:04 +0200 (CEST)
>>
>>  
>>> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=14378
>>> Subject        : Problems with net/core/skbuff.c
>>> Submitter    : Massimo Cetra <mcetra@navynet.it>
>>> Date        : 2009-10-08 14:51 (4 days old)
>>> References    : http://marc.info/?l=linux-kernel&m=125501488220358&w=4
>>>     
>>
>> I don't know what to do about this one.
>>
>> The user indicates that they have the vserver patches applied,
>> so maybe there is some interaction with that stuff.
>>   
> Actually i found another oops which is very similar to the previous one.

And here it is another one, this time triggered by postfix, where mor 
drbd nor vserver are involved.
This is not the same server where the other oopses were grabbed.

Max



