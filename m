Return-Path: <linux-kernel-owner+w=401wt.eu-S932583AbXC1COI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbXC1COI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 22:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933112AbXC1COI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 22:14:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:15397 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583AbXC1COH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 22:14:07 -0400
Message-ID: <4609CF4A.1030809@oracle.com>
Date: Tue, 27 Mar 2007 19:13:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: bryan.wu@analog.com
CC: Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Blackfin arch: add kdebug header file
References: <1174903941.32691.72.camel@roc-desktop>	 <200703262345.09489.arnd@arndb.de> <1174966837.6966.13.camel@roc-desktop>	 <20070327035734.GA25883@linux-sh.org>	 <8bd0f97a0703262134h20bdf8dcqb1043ca176a7149c@mail.gmail.com>	 <20070327044914.GA26099@linux-sh.org>	 <8bd0f97a0703262217g16aa62d4g1221082deda0aed2@mail.gmail.com>	 <20070326222711.d2f42da2.randy.dunlap@oracle.com>	 <1174974045.6966.26.camel@roc-desktop>	 <20070327083437.e1d6b954.randy.dunlap@oracle.com> <1175047573.15391.2.camel@roc-desktop>
In-Reply-To: <1175047573.15391.2.camel@roc-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>>>> In that case, Bryan may like to know that git, mercurial (IIRC),
>>>> and quilt have patchbomb tools.  Also GregKH has one somewhere (he
>>>> can tell you where).  And Paul Jacksone has one at
>>>>   http://www.speakeasy.org/~pj99/sgi/sendpatchset

> 
> Thanks a lot, I will try on my side. And one more question:
> 
> What is patchbomb tools, you mean git, quilt or other kernel patch
> management tool? I am using quilt and try to use git to manage patches.
> Is there a tool just named patchbomb?

No, just the scripts listed above, including quilt & git (except that I can't
find GregKH's script).

-- 
~Randy

PS:  I typo-ed Paul Jackson's name above.  :(
