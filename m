Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYDWUyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYDWUyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 16:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbYDWUx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 16:53:59 -0400
Received: from service2.sh.cvut.cz ([147.32.127.218]:58370 "EHLO
	service2.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbYDWUx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 16:53:59 -0400
Message-ID: <480FA235.8000203@seznam.cz>
Date: Wed, 23 Apr 2008 22:55:17 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       John Linn <John.Linn@xilinx.com>, git-dev@xilinx.com,
       Grant Likely <grant.likely@secretlab.ca>, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: Microblaze Linux release
References: <48020A21.4000404@seznam.cz> <200804160944.42734.arnd@arndb.de> <48061B36.20800@seznam.cz> <200804161733.04714.arnd@arndb.de>
In-Reply-To: <200804161733.04714.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I update Microblaze kernel to latest Linus tree. I fixed some problems which
come with it.

Regards,
Michal


>>> One more reason for the microblaze kernel to base on top of linux-next
>>> instead of mainline.
>> For me is not difficult to use lmb from microblaze/mm or from lib if the files
>> are the same.
>>
> 
> What I meant is that there are a number of reasons to use linux-next
> as a base for your kernel (this being one of them) and few against.
> 
> 	Arnd <><
> 
> 
