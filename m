Return-Path: <linux-kernel-owner+w=401wt.eu-S2992828AbXDYQdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992828AbXDYQdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 12:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992829AbXDYQdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 12:33:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:32786 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992828AbXDYQdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 12:33:31 -0400
Message-ID: <462F82EB.8020404@oracle.com>
Date: Wed, 25 Apr 2007 09:33:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Mel Gorman <mel@skynet.ie>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       y-goto@jp.fujitsu.com, apw@shadowen.org
Subject: Re: + handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64.patch
 added to -mm tree
References: <200704242104.l3OL4SV3019236@shell0.pdx.osdl.net> <20070425080846.3b03299c.randy.dunlap@oracle.com> <20070425162313.GA30246@skynet.ie>
In-Reply-To: <20070425162313.GA30246@skynet.ie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On (25/04/07 08:08), Randy Dunlap didst pronounce:
>> On Tue, 24 Apr 2007 14:04:28 -0700 akpm@linux-foundation.org wrote:
>>
>>> The patch titled
>>>      Handle kernelcore= boot parameter in common code to avoid boot problem on IA64
>>> has been added to the -mm tree.  Its filename is
>>>      handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64.patch
>>>
>>> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>>>
>>> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
>>> out what to do about this
>>>
>>> ------------------------------------------------------
>>> Subject: Handle kernelcore= boot parameter in common code to avoid boot problem on IA64
>>> From: Yasunori Goto <y-goto@jp.fujitsu.com>
>>>
>>> When "kernelcore" boot option is specified, kernel can't boot up on ia64
>>> because of an infinite loop.  In addition, the parsing code can be handled
>>> in an architecture-independent manner.
>> Is this boot option documented anywhere in the kernel source tree?
>>
> 
> Documentation/kernel-parameters.txt

Thanks, my bad.  I failed to look at that file in -mm.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
