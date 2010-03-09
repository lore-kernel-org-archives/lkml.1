Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab0CIRJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:09:14 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:60800 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab0CIRJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:09:12 -0500
Message-ID: <4B968033.5090006@oracle.com>
Date: Tue, 09 Mar 2010 09:06:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: linux-next: Tree for March 8 (mtd)
References: <20100308152740.a007e8cb.sfr@canb.auug.org.au>	 <4B9532FE.8030901@oracle.com> <1268102942.3908.957.camel@macbook.infradead.org>
In-Reply-To: <1268102942.3908.957.camel@macbook.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B9680A6.01C4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/10 18:49, David Woodhouse wrote:
> On Mon, 2010-03-08 at 09:25 -0800, Randy Dunlap wrote:
>> On 03/07/10 20:27, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20100305:
>>>
>>>
>>> The mtd tree still has its 2 build failures for which I applied patches.
>>
>>
>> drivers/mtd/sm_ftl.c:
>> sm_ftl.c:(.text+0x9c110): undefined reference to `__nand_calculate_ecc'
>> sm_ftl.c:(.text+0x9c123): undefined reference to `__nand_correct_data'
>> sm_ftl.c:(.text+0x9c14a): undefined reference to `__nand_calculate_ecc'
>> sm_ftl.c:(.text+0x9c15d): undefined reference to `__nand_correct_data'
>> sm_ftl.c:(.text+0x9c9ac): undefined reference to `__nand_calculate_ecc'
>> sm_ftl.c:(.text+0x9c9bf): undefined reference to `__nand_calculate_ecc'
> 
> Thanks.
> 
> http://git.infradead.org/mtd-2.6.git/commitdiff/7de6f798
> 

Ack.  Thanks.

-- 
~Randy
