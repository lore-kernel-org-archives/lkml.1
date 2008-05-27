Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbYE0TQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbYE0TQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 15:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbYE0TQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 15:16:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38810 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728AbYE0TQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 15:16:44 -0400
Message-ID: <483C5DF4.60508@zytor.com>
Date: Tue, 27 May 2008 12:16:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu
Subject: Re: [PATCH 10/10] x86 boot: add code to add BIOS provided EFI memory
 entries to kernel
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>	<20080514151558.148486.91282.sendpatchset@jackhammer.engr.sgi.com>	<1211857948.12819.84.camel@caritas-dev.intel.com> <20080527140848.ce57845b.pj@sgi.com>
In-Reply-To: <20080527140848.ce57845b.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> 
> But I reply mine is better, because we can already provide, with the
> current EFI interfaces, all the entries from the boot loader to the
> kernel, so we do not need to provide them twice, a second time via an
> E820 map mechanism that must be revised and extended to handle the
> additional memory map entries past the first 128 of them.
> 

This was discussed over a year ago, and it was declared the boot 
loaders' responsibility.  Please go back and look at the archives for 
the discussion rather than rehashing it at this time.

	-hpa
