Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbZCFTkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbZCFTkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZCFTjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:39:55 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:46418 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbZCFTjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:39:54 -0500
Message-ID: <49B17C4E.3000004@oracle.com>
Date: Fri, 06 Mar 2009 11:41:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: linux-next: Tree for March 6 (ath9k)
References: <20090306191311.697e7b97.sfr@canb.auug.org.au> <49B17320.8010000@oracle.com> <49B17B12.3050200@openwrt.org>
In-Reply-To: <49B17B12.3050200@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49B17BEB.0024:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabor Juhos wrote:
> Randy Dunlap írta:
>> Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Linus' release of -rc7 seems to have stirred people up a bit ...
>>>
>>> Changes since 20090305:
>>
>> when CONFIG_RFKILL=n, ath9k/virtual.c causes:
>>
>> (.text+0x224e83): undefined reference to `ath_radio_disable'
>> (.text+0x224e8b): undefined reference to `ath_radio_enable'
>>
>>
> 
> Hi,
> 
> I have submitted a patch for this already:
> http://marc.info/?l=linux-wireless&m=123633468314970&w=2
> 
> Should I send it to somewhere else as well?

It hasn't propagated into the linux-next merging yet...


-- 
~Randy
