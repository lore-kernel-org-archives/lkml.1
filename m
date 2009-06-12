Return-Path: <linux-kernel-owner+w=401wt.eu-S1764221AbZFLKPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764221AbZFLKPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764116AbZFLKPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:15:25 -0400
Received: from mx.sz.bfs.de ([194.94.69.70]:55699 "EHLO mx.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763639AbZFLKPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:15:21 -0400
Message-ID: <4A322A73.4040104@bfs.de>
Date: Fri, 12 Jun 2009 12:14:11 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jiri Kosina <trivial@kernel.org>
Cc: Markus Heidelberg <markus.heidelberg@web.de>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] trivial: update the Kernel Janitors' web-page URL
References: <1244761228-32644-1-git-send-email-markus.heidelberg@web.de> <alpine.LNX.2.00.0906121057240.7457@wotan.suse.de>
In-Reply-To: <alpine.LNX.2.00.0906121057240.7457@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Jiri Kosina schrieb:
> On Fri, 12 Jun 2009, Markus Heidelberg wrote:
> 
>> The former address cannot be resolved.
>>
>> Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
>> ---
>>  MAINTAINERS |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index ccdb575..d37b6a0 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -3267,7 +3267,7 @@ F:	scripts/Makefile.*
>>  KERNEL JANITORS
>>  P:	Several
>>  L:	kernel-janitors@vger.kernel.org
>> -W:	http://www.kerneljanitors.org/
>> +W:	http://janitor.kernelnewbies.org/
>>  S:	Maintained
> 
> BTW, I haven't followed kernel janitors project for a while, is it still 
> active? Skimming through the web, I can see some TODOs from 2001, hence 
> the question :)
> 
> Thanks,
> 


the project is still active.

the last patch was yesterday:
<clip>
Trivial patch which adds the __init and __exit macros to the module_init /
module_exit functions to the following modules from drivers/mtd/
 devices/m25p80.c
 devices/slram.c
 linux version 2.6.30
 ftl.c
 nand/cafe_nand.c
 nand/cmx270_nand.c
<clip/>


re,
 wh
