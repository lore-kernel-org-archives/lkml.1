Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbZAJFKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbZAJFKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 00:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbZAJFKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 00:10:10 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:31985 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZAJFKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 00:10:09 -0500
Message-ID: <49682D9E.5020804@oracle.com>
Date: Fri, 09 Jan 2009 21:09:50 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       a.beregalov@gmail.com
Subject: Re: + irda-fix-incomplete-conversation-to-internal-stats.patch added
 to -mm tree
References: <200901100023.n0A0N9st031030@imap1.linux-foundation.org>	<20090109.171201.80737529.davem@davemloft.net> <20090109174341.25d5527a.akpm@linux-foundation.org>
In-Reply-To: <20090109174341.25d5527a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49682DA1.00F1:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 09 Jan 2009 17:12:01 -0800 (PST) David Miller <davem@davemloft.net> wrote:
> 
>> From: akpm@linux-foundation.org
>> Date: Fri, 09 Jan 2009 16:23:09 -0800
>>
>>> Subject: irda: fix incomplete conversation to internal stats
>>> From: Alexander Beregalov <a.beregalov@gmail.com>
>>>
>>> Fix for commit af0490810c (irda: convert to internal stats)
>>>
>>> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
>>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> Andrew, this is already in the net-2.6 GIT tree, so you can safely
>> toss this.
> 
> I added it so I could compile my stuff.

to be clear, it's broken in mainline, linux-next, and -mm
until some patch is merged.

>> commit 35a2f9993e1bef0d09c3d737aef784caaa888b48
>> Author: Alexander Beregalov <a.beregalov@gmail.com>
>> Date:   Thu Jan 8 16:42:08 2009 -0800
>>
>>     irda: fix incomplete conversation to internal stats
>>     
>>     Fix for commit af0490810c (irda: convert to internal stats)
>>     
>>     Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
>>     Signed-off-by: David S. Miller <davem@davemloft.net>


-- 
~Randy
