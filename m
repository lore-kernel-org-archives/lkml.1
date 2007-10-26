Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbXJZEPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbXJZEPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 00:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbXJZEPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 00:15:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48510 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbXJZEPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 00:15:38 -0400
Message-ID: <47216905.2030207@zytor.com>
Date: Thu, 25 Oct 2007 21:11:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
 runtime service support
References: <1193295473.23935.202.camel@caritas-dev.intel.com>	 <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain> <1193369792.23935.283.camel@caritas-dev.intel.com>
In-Reply-To: <1193369792.23935.283.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> 
> - 3 files: efi.c, efi_32.c, efi_64.c, common code goes in efi.c, EFI
> 32/64 specific code goes in efi_32/64.c. This will make some variable,
> function external instead of static.
> 

This is preferred.

	-hpa
