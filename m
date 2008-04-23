Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbYDWU4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbYDWU4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 16:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbYDWU4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 16:56:39 -0400
Received: from service2.sh.cvut.cz ([147.32.127.218]:59170 "EHLO
	service2.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbYDWU4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 16:56:39 -0400
Message-ID: <480FA2D6.1050108@seznam.cz>
Date: Wed, 23 Apr 2008 22:57:58 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       benh@kernel.crashing.org, John Linn <John.Linn@xilinx.com>,
       git-dev@xilinx.com, Grant Likely <grant.likely@secretlab.ca>,
       git@xilinx.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: Microblaze Linux release
References: <48020A21.4000404@seznam.cz> <200804140801.57464.arnd@arndb.de> <4804A59B.5040909@seznam.cz> <200804151532.11619.arnd@arndb.de>
In-Reply-To: <200804151532.11619.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

>>> * The semaphore implementation will be obsolete in 2.6.26
>> I don't know. Which cpu has correct implemetnation?
> 
> 2.6.26 will have a common implementation in kernel/semaphore.c.
> All you need is a one-line asm/semaphore.h to #include linux/semaphore.h.

I fixed this issue.

Regards,
Michal Simek
