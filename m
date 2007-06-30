Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbXF3Xmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbXF3Xmo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 19:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbXF3Xmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 19:42:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:11459 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbXF3Xmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 19:42:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=MGzmpPHNhsz/++YNs10Uqlu09TbYqhHHajXaZGn1S17SjtGWh/Z+x0m/L9paZbyBuCDtV35W9LZiZeeyn6dp5w+Qm/wP2m42gznzmaQ+3nHnGw+xOICHX588IKe4IdCME98wuecd0f1Vl82NMxU/oZAumkI70g3bMngDU2b12l4=
Message-ID: <4686EA4A.9070306@googlemail.com>
Date: Sun, 01 Jul 2007 01:42:02 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Stephane Eranian <eranian@hpl.hp.com>,
       =?ISO-8859-1?Q?Bj=F6rn_Steinbri?= =?ISO-8859-1?Q?nk?= 
	<B.Steinbrink@gmx.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Trent Piepho <xyzzy@speakeasy.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [1/2] 2.6.22-rc6: known regressions with patches
References: <467F8F5A.3000205@googlemail.com> <20070630192045.GA3720@elte.hu>
In-Reply-To: <20070630192045.GA3720@elte.hu>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Ingo Molnar pisze:
> * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
>> Subject    : fix nmi_watchdog=2 bootup hang
>> References : http://lkml.org/lkml/2007/6/25/51
>> Submitter  : Ingo Molnar <mingo@elte.hu>
>> Caused-By  : Jeremy Fitzhardinge <jeremy@xensource.com>
>>             Andi Kleen <ak@suse.de>
>>             commit f8822f42019eceed19cc6c0f985a489e17796ed8
>> Status     : patch available
> 
> fixed by:
> 
>  commit b9e3614f444f6546204f4538afcaa3ebe36d49f2
>  Author: Bj<C3><B6>rn Steinbrink <B.Steinbrink@gmx.de>
>  Date:   Mon Jun 25 23:04:37 2007 +0200
> 
>      fix nmi_watchdog=2 bootup hang
> 
> 	Ingo
> 


It's already removed

364  	2007-06-27 00:19:54  	8494  	 	mkkp  	"fix nmi_watchdog=2 bootup hang" fixed

Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
