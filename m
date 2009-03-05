Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbZCEXFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbZCEXFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 18:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346AbZCEXF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 18:05:29 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:22522 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbZCEXF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 18:05:28 -0500
Message-ID: <49B05ACF.2010708@oracle.com>
Date: Thu, 05 Mar 2009 15:05:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Yinghai Lu <yinghai@kernel.org>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, ebiederm@xmission.com,
       akpm@linux-foundation.org, gregkh@suse.de, tglx@linutronix.de,
       sarah.a.sharp@intel.com, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
References: <Pine.LNX.4.44L0.0903051751330.2174-100000@iolanthe.rowland.org> <1236294142.5937.88.camel@desktop>
In-Reply-To: <1236294142.5937.88.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.49B05A72.0285:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Thu, 2009-03-05 at 17:54 -0500, Alan Stern wrote:
>> On Thu, 5 Mar 2009, Daniel Walker wrote:
>>
>>> Fix up some typos, and make the requirements section slightly cleaner.
>>>
>>> Signed-Off-By: Daniel Walker dwalker@fifo99.com
>>>
>>> diff --git a/Documentation/x86/earlyprintk.txt b/Documentation/x86/earlyprintk.txt
>>> index 607b1a0..5b51aef 100644
>>> --- a/Documentation/x86/earlyprintk.txt
>>> +++ b/Documentation/x86/earlyprintk.txt
>>> @@ -9,7 +9,9 @@ and two USB cables, connected like this:
>>>  
>>>  1. There are three specific hardware requirements:
>>>  
>>> - a.) Host/target system needs to have USB debug port capability.
>>> + a.) You will need two USB ports. One on the client/console system and one one the target system.
>> s/one one/one on/
> 
> Check.
> 
>> You might also try harder to observe the 80-column rule.
> 
> I wasn't aware it applied to documents ..

Yes, it does.


Thanks.
-- 
~Randy
