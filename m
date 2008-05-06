Return-Path: <linux-kernel-owner+w=401wt.eu-S1764624AbYEFJD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764624AbYEFJD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763030AbYEFI43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:56:29 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:58456 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762928AbYEFI40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:56:26 -0400
Message-ID: <48201D5F.7050707@seznam.cz>
Date: Tue, 06 May 2008 10:57:03 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, monstr@seznam.cz, paulus@samba.org, arnd@arndb.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] OF: Fix coding style violation in of_device.c and
 of_platform.c
References: <1209824532-7939-1-git-send-email-monstr@seznam.cz>	<765c6c8053679c45eb370255a110f7bc680a8f25.1209824033.git.monstr@monstr.eu>	<20080505095649.fccb57bf.sfr@canb.auug.org.au> <20080504.170611.112259062.davem@davemloft.net>
In-Reply-To: <20080504.170611.112259062.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi David and Stephen,

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 5 May 2008 09:56:49 +1000
> 
>> Any changes to the drivers of files should be cc'd to me (who did the
>> initial splitup) and Dave Miller since you may impact the sparc code
>> (which is the other user).
> 
> I tried to stitch these patches together and apply them to Linus's
> tree for some sparc test builds the other day, but failed.
> 
> I can't figure out what this mess is against. :-/

Microblaze use the same code(of_device.c and of_platform.c) as is in powerpc.
I have only minor changes in prom.c.

Michal
