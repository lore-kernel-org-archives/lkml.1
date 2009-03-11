Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZCKRSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZCKRSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZCKRSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:18:30 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:44650 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZCKRS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:18:29 -0400
Message-ID: <49B7F2B0.1000702@oracle.com>
Date: Wed, 11 Mar 2009 10:19:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Gabor Juhos <juhosg@openwrt.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for March 6 (ath9k)
References: <20090306191311.697e7b97.sfr@canb.auug.org.au> <49B17320.8010000@oracle.com> <49B17B12.3050200@openwrt.org> <49B17C4E.3000004@oracle.com> <20090306194045.GE3712@tuxdriver.com>
In-Reply-To: <20090306194045.GE3712@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49B7F240.01DC:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John W. Linville wrote:
> On Fri, Mar 06, 2009 at 11:41:02AM -0800, Randy Dunlap wrote:
>> Gabor Juhos wrote:
>>> Randy Dunlap írta:
>>>> Stephen Rothwell wrote:
>>>>> Hi all,
>>>>>
>>>>> Linus' release of -rc7 seems to have stirred people up a bit ...
>>>>>
>>>>> Changes since 20090305:
>>>> when CONFIG_RFKILL=n, ath9k/virtual.c causes:
>>>>
>>>> (.text+0x224e83): undefined reference to `ath_radio_disable'
>>>> (.text+0x224e8b): undefined reference to `ath_radio_enable'
>>>>
>>>>
>>> Hi,
>>>
>>> I have submitted a patch for this already:
>>> http://marc.info/?l=linux-wireless&m=123633468314970&w=2
>>>
>>> Should I send it to somewhere else as well?
>> It hasn't propagated into the linux-next merging yet...
> 
> He just sent it today (or overnight).  I'll get it into wireless-next.
> 
> John
> 
> P.S.  I'm starting to think that RFKILL should just be mandatory...


This build error still happens in linux-next-20090311.

-- 
~Randy
