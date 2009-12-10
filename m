Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbZLJDNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbZLJDNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 22:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758730AbZLJDNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 22:13:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758697AbZLJDNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 22:13:42 -0500
Date: Wed, 9 Dec 2009 19:13:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Greg Ungerer <gerg@snapgear.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>
cc: gerg@uclinux.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-m68k@vger.kernel.org
Subject: Re: [git pull] m68knommu arch updates
In-Reply-To: <200912090758.nB97wPok013748@goober.internal.moreton.com.au>
Message-ID: <alpine.LFD.2.00.0912091910340.3560@localhost.localdomain>
References: <200912090758.nB97wPok013748@goober.internal.moreton.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Dec 2009, Greg Ungerer wrote:
> 
> Please pull to get the latest m68knommu arch fixes. Not a lot in here,
> mostly small fixes. The biggest change is Tim Abbott's linker script
> cleanups.

Hmm. I got a conflict due to the other m68k changes on the file 
arch/m68k/include/asm/ptrace.h.

I fixed it up the way that seemed most appropriate, but somebody should 
double-check. My resolution is not identical to either source branch tree.

		Linus
