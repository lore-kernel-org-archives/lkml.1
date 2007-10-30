Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbXJ3TGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbXJ3TGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbXJ3TGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:06:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42384 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752459AbXJ3TGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:06:21 -0400
Date: Tue, 30 Oct 2007 12:06:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: Robert Hancock <hancockr@shaw.ca>, Greg KH <greg@kroah.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       rajesh.shah@intel.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
In-Reply-To: <200710301950.58519.ak@suse.de>
Message-ID: <alpine.LFD.0.999.0710301205180.30120@woody.linux-foundation.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org>
 <47267232.3020506@shaw.ca> <alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org>
 <200710301950.58519.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Oct 2007, Andi Kleen wrote:
> 
> Also there are still the old x86 Macs where conf1 doesn't work.

I don't think that was ever true. That was a made-up rumor by the EFI 
people who were just confused.

There's no way to disable conf1 accesses on any known chipset, afaik.

		Linus
