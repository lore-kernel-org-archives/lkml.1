Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab0BMKZJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 05:25:09 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35233 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0BMKZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 05:25:07 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B767D34.2080909@s5r6.in-berlin.de>
Date: Sat, 13 Feb 2010 11:21:40 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Willy Tarreau <w@1wt.eu>, Jean Delvare <khali@linux-fr.org>,
       lasse.collin@tukaani.org, linux-kernel <linux-kernel@vger.kernel.org>,
       mirrors@kernel.org, users@kernel.org,
       "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [kernel.org users] XZ Migration discussion
References: <4B744E13.8040004@kernel.org> <20100212150137.648dca7c@hyperion.delvare> <alpine.LFD.2.00.1002120714320.7792@localhost.localdomain> <4B75A5DC.3060803@kernel.org> <20100212202357.6363d5af@hyperion.delvare> <20100212230702.GA10266@1wt.eu> <20100213062004.GA22848@elf.ucw.cz> <4B767989.1010200@s5r6.in-berlin.de>
In-Reply-To: <4B767989.1010200@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Pavel Machek wrote:
>>> And Peter raised some valid points about the hardware requirements
>>> to run such tools ; I'm not sure the guys running Linux on their old
>>> Sparc-2 would like XZ only a lot.
>> It is not just student on old workstation. I'm trying to keep Linux
>> working on spitz PDA and kohjinsha subnotebook. Especially zaurus has
>> about power of old sparc two...
> 
> Do you actually require to download and unpack (and configure, build)
> the kernel sources from kernel.org to the PDA directly?  As Jean wrote,
> how does unpack time matter compared to build time?

PS:  It boils down to CPU time requirements.  For small memory systems,
there is the XZ Embedded decompressor.
-- 
Stefan Richter
-=====-==-=- --=- -==-=
http://arcgraph.de/sr/
