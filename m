Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbXFWVGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbXFWVGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 17:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXFWVGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 17:06:13 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:36265 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbXFWVGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 17:06:12 -0400
Message-ID: <467D8AC9.8060001@oracle.com>
Date: Sat, 23 Jun 2007 14:04:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Oleg Verych <olecom@flower.upol.cz>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: NAK (bashizm in the /bin/sh script): [PATCH v3]	doc/oops-tracing:
 add Code: decode info
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com> <200706221626.39969.ak@suse.de> <20070622094429.0910c7cb.randy.dunlap@oracle.com> <200706221923.02736.ak@suse.de> <20070622132810.3c758590.randy.dunlap@oracle.com> <E1I2159-0005AH-DS@flower> <20070623104303.a186c5a8.randy.dunlap@oracle.com> <20070623105645.ad4dbace.akpm@linux-foundation.org> <20070623205426.GQ23017@stusta.de>
In-Reply-To: <20070623205426.GQ23017@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Jun 23, 2007 at 10:56:45AM -0700, Andrew Morton wrote:
>> On Sat, 23 Jun 2007 10:43:03 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>>>> NAK.
>>> Sorry I slept thru another wonderful festival on LKML.
>> That's probably the best strategy.
>>
>>> You don't have the authority to NAK the patch.
>> Yeah.  nak to naks.
>>
>>> OTOH, you also didn't supply a patch.  If you do this, I'll be
>>> glad to consider it.  If I can read it, that is.
>> Yes, I plan on merging that patch as-is.  If it was a compulsory part of
>> kbuild then that would be a problem but as some optional tool I don't think
>> that a bashism matters much.  Someone can fix it sometime should they feel
>> so motivated.
> 
> Oleg didn't express it very polite, but he has a valid point that bash 
> scripts should start with "#!/bin/bash" since /bin/sh might be some 
> shell other than bash.
> 
> Randy, am I right to assume that such a change to your patch would be OK?

Sure.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
