Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbXKUGLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbXKUGLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 01:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbXKUGLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 01:11:30 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:57920 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752064AbXKUGL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 01:11:29 -0500
Message-ID: <4743CC0B.9000508@linux.vnet.ibm.com>
Date: Wed, 21 Nov 2007 11:41:23 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc3-mm1 - Kernel Panic on IO-APIC
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
In-Reply-To: <20071120204525.ff27ac98.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Kernel panic's across different architectures like powerpc, x86_64, 

Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
Mount-cache hash table entries: 256
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
..MP-BIOS bug: 8254 timer not connected to IO-APIC
Kernel panic - not syncing: IO-APIC + timer doesn't work! Try using the 'noapic' kernel parameter

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
