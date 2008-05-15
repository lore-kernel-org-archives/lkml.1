Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbYEOHVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbYEOHVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYEOHVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:21:15 -0400
Received: from relay4.jackal-net.at ([193.154.151.101]:43532 "EHLO
	vm02.server04.jackal-net.at" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752781AbYEOHVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:21:14 -0400
Message-ID: <482BE440.9070206@jackal-net.at>
Date: Thu, 15 May 2008 09:20:32 +0200
From: Michael Lang <Michael.Lang@jackal-net.at>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: Kernel Panic when accessing NFS share and locking files
References: <482B2108.4090902@jackal-net.at>	<20080514204932.13243cab.akpm@linux-foundation.org> <20080514205528.3bf3955d@infradead.org>
In-Reply-To: <20080514205528.3bf3955d@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Milter: vm02.server04.jackal-net.at
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 14 May 2008 20:49:32 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>   
>> On Wed, 14 May 2008 19:27:36 +0200 Michael Lang
>> <Michael.Lang@jackal-net.at> wrote:
>>
>>     
>>> Hi,
>>>
>>> we encountered a serious problem, when using Solaris NFS (Server) 
>>> accessing it with a CentOS5.1/RHEL5.1 client.
>>>       
>
>
>
>   
>> Which kernel version is being used?
>>     
>
> that'll be a 2.6.18 variant ;)
>
> there have been some, but not too many, reports of a trace like this:
> http://www.kerneloops.org/search.php?search=__fput
>   
thanks for your quick response ...

yes it's the hole 2.6.18+ series which is provided by RedHat, i'm 
currently compiling a 2.6.25-3 to verify that the problem still persists in
the new versions. I'll try to get it running today an let you know, if 
so i'll forward the code and instructions how to recreate the problem to the
enclosed recipients only ...

kind regards
Michael Lang


