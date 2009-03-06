Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbZCFUIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbZCFUIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 15:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbZCFUIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 15:08:15 -0500
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:56505 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbZCFUIO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 15:08:14 -0500
X-Greylist: delayed 1941 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Mar 2009 15:08:13 EST
Message-ID: <49B17B12.3050200@openwrt.org>
Date: Fri, 06 Mar 2009 20:35:46 +0100
From: Gabor Juhos <juhosg@openwrt.org>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for March 6 (ath9k)
References: <20090306191311.697e7b97.sfr@canb.auug.org.au> <49B17320.8010000@oracle.com>
In-Reply-To: <49B17320.8010000@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
X-Antivirus: avast! (VPS 090305-1, 2009.03.05), Outbound message
X-Antivirus-Status: Clean
Content-Transfer-Encoding: 8BIT
X-VBMS: A15C8761299 | phoenix3 | 127.0.0.1 |  | <juhosg@openwrt.org> | 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap írta:
> Stephen Rothwell wrote:
>> Hi all,
>>
>> Linus' release of -rc7 seems to have stirred people up a bit ...
>>
>> Changes since 20090305:
> 
> 
> when CONFIG_RFKILL=n, ath9k/virtual.c causes:
> 
> (.text+0x224e83): undefined reference to `ath_radio_disable'
> (.text+0x224e8b): undefined reference to `ath_radio_enable'
> 
> 

Hi,

I have submitted a patch for this already:
http://marc.info/?l=linux-wireless&m=123633468314970&w=2

Should I send it to somewhere else as well?

Gabor


