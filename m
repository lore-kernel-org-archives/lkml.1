Return-Path: <linux-kernel-owner+w=401wt.eu-S934942AbZDHRhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934942AbZDHRhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934792AbZDHRhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:37:19 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:62684 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934472AbZDHRhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:37:16 -0400
Message-ID: <49DCE0A9.5020308@oracle.com>
Date: Wed, 08 Apr 2009 10:36:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org
Subject: Re: cross-compilers
References: <20090408003921.GA5054@ldl.fc.hp.com> <20090408010331.GB10768@sgi.com> <20090408054612.GA6744@ldl.fc.hp.com> <20090407225457.86f8a458.akpm@linux-foundation.org> <20090408173332.GB20187@ldl.fc.hp.com>
In-Reply-To: <20090408173332.GB20187@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49DCE09C.01F0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> * Andrew Morton <akpm@linux-foundation.org>:
>> On Tue, 7 Apr 2009 23:46:12 -0600 Alex Chiang <achiang@hp.com> wrote:
>>
>>> * Robin Holt <holt@sgi.com>:
>>>> Don't know if this answers your problem, but I use the tools from
>>>> emdebian and they do not suffer from the problems you list below.
>>> Wow, this seems _much_ simpler. Once you get the toolchain
>>> installed, all you have to do is set ARCH and CROSS_COMPILE
>>> appropriately?
>>>
>>> I guess the question remains for Andrew. Since I pretty much did
>>> all the work needed to update his cross-compiler repo, is there
>>> still value in it?
>> We would benefit very much from having someone who actually maintains a
>> suite of cross-compilers for kernel developers.
>  
> Ok, I'll work with Vegard on this.
> 
> Thanks.

Thank you.  We should be able to have these tools
without using any specific $distro.

-- 
~Randy
