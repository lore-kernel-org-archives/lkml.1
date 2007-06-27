Return-Path: <linux-kernel-owner+w=401wt.eu-S1761466AbXF0OMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761466AbXF0OMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbXF0OMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:12:33 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:45393 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbXF0OMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:12:32 -0400
Message-ID: <4682708A.5040509@oracle.com>
Date: Wed, 27 Jun 2007 07:13:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: gshan <gshan@alcatel-lucent.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6 Linux for PowerPC supports kdb?
References: <4681D39B.2000604@alcatel-lucent.com> <20070626220520.380c1798.randy.dunlap@oracle.com> <4682007F.2080504@alcatel-lucent.com>
In-Reply-To: <4682007F.2080504@alcatel-lucent.com>
Content-Type: text/plain; charset=windows-1256; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

gshan wrote:
> Randy Dunlap wrote:
>> On Tue, 26 Jun 2007 23:03:55 -0400 Shan, Guo Wen (Gavin) wrote:
>>
>>  
>>> Does anybody knew if 2.6 linux for PowerPC supports kdb?
>>>     
>>
>> PowerPC isn't listed AFAICT:
>> ftp://oss.sgi.com/www/projects/kdb/download/v4.4/README
>>
>> I.e., all that I see are i386, x86_64, and ia64.
>>
>> ---
>> ~Randy
>> *** Remember to use Documentation/SubmitChecklist when testing your 
>> code ***
>>   
> Thanks, Randy. So the kgdb is the only tool I could use to debug the 
> kernel right now?

AFAIK, yes.

-- 
~Randy
