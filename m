Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbXFUIoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbXFUIoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 04:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbXFUIoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 04:44:10 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:36407 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbXFUIoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 04:44:08 -0400
Message-ID: <467A3A48.6050809@linux.vnet.ibm.com>
Date: Thu, 21 Jun 2007 14:13:52 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jarek Poplawski <jarkao2@o2.pl>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [ANNOUNCE] Linux Kernel =?windows-1252?Q?Tester=92s_Guide_?=
 =?windows-1252?Q?v0=2E3-rc1?=
References: <4676E707.8020109@googlemail.com> <661de9470706210031s36396c31xff5428ff60042073@mail.gmail.com> <6bffcb0e0706210130h227dcd62n52f34e45dfd8e818@mail.gmail.com>
In-Reply-To: <6bffcb0e0706210130h227dcd62n52f34e45dfd8e818@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Hi Balbir,
> 
> On 21/06/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> Wonderful! Are there any plans to start using the fault injection
>> framework
>> to catch more defects?
> 
> There are plans for the second part called "debugging techniques", but
> I really don't know when I'll start writing this.
> 
> In fact I don't even know if it will be useful for testers. IMHO it is
> for developers not for testers.
> 
> Regards,
> Michal
> 

I thought so too, but being able to randomly fail allocations on a system
might expose the system error handling and recovery capabilities.

It'll also be interesting to see if testing is catching bugs, that tools
(such as sparse) could have caught.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
