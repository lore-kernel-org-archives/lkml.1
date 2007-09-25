Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbXIYVMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbXIYVMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 17:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbXIYVMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 17:12:35 -0400
Received: from barikada.upol.cz ([158.194.242.200]:41370 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbXIYVMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 17:12:34 -0400
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch 3/5] Add samples subdir
In-Reply-To: <20070925190036.GA14579@uranus.ravnborg.org>
References: <20070925121145.262664884@polymtl.ca> <20070925121251.954162366@polymtl.ca> <20070925190036.GA14579@uranus.ravnborg.org>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Tue, 25 Sep 2007 23:28:18 +0200
Message-Id: <E1IaHx4-0001Kt-JT@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Tue, 25 Sep 2007 21:00:36 +0200
>
> Hi Mathieu & Randy.
>
> On Tue, Sep 25, 2007 at 08:11:48AM -0400, Mathieu Desnoyers wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>> 
>> Begin infrastructure for kernel code samples in the samples/ directory.
>> Add its Kconfig and Kbuild files.
>> Source its Kconfig file in all arch/ Kconfigs.
>
> Sorry for not commenting on this before...
> The samples directory contains sample code so it is wrong to actually
> include it as part of the kernel IMHO.

Count my HO too.

Kernel isn't school desk at first place. It's already bloated as with
various 2+y obsolete changelogs (that have content, that even older),
with unsorted documentation (hypertext and http are better on this).

Up to date test cases and example code must be on developer's site,
not as burden in the sources. Yea, linux tar ball is a popular one.
But sorry, it already has too much unneeded stuff for most of the
freelance users and testers. This tarball must have good end result
with propper changelogs and pointers to *fresh* information.
--
-o--=O`C
 #oo'L O
<___=E M
