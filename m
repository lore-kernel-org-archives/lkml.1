Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbYDMQHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbYDMQHY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 12:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbYDMQHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 12:07:12 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:52146 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751325AbYDMQHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 12:07:11 -0400
Message-ID: <48022A4C.8000601@seznam.cz>
Date: Sun, 13 Apr 2008 17:44:12 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       benh@kernel.crashing.org, John Linn <John.Linn@xilinx.com>,
       git-dev@xilinx.com, git@xilinx.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: Microblaze Linux release
References: <48020A21.4000404@seznam.cz> <fa686aa40804130633p49be1e12sdbd14e5efd1bdf68@mail.gmail.com>
In-Reply-To: <fa686aa40804130633p49be1e12sdbd14e5efd1bdf68@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

as I wrote. I am working on it. I'll send them ASAP.


Michal

>> Hi Everybody,
>>
>>  I fixed all reported bugs which I got from LKML and from you.
>>  Latest version of Microblaze Linux kernel is available at git.monstr.eu.
>>  There is git repository called linux-microblaze.git
>>  Microblaze port is based on 2.6.24-rc5. I'll create the new repo with clean pack
>>  of changes based on latest kernel version for easier pull.
>>
>>  Merge windows will be open hopefully next week and I would like to send pull
>>  request to Paul.
>>
>>  I would like to ask you for review all microblaze code especially
>>  arch/microblaze and include/asm-microblaze. Please don't send me question to
>>  drivers - Microblaze will use only uartlite driver (only add on or to Kconfig -
>>  that's enough for now).
> 
> Can you please also post your updated patch series?  Reviewing patches
> is easy.  Reviewing a git tree is a lot more work.
> 
> Thanks,
> g.
> 
