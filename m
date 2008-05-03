Return-Path: <linux-kernel-owner+w=401wt.eu-S1760877AbYECGff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877AbYECGff (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 02:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbYECGf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 02:35:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754789AbYECGf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 02:35:27 -0400
Date: Fri, 2 May 2008 23:35:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: Requirements and process
Message-Id: <20080502233519.a988b552.akpm@linux-foundation.org>
In-Reply-To: <20080503154542.18807e59.sfr@canb.auug.org.au>
References: <20080503154542.18807e59.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008 15:45:42 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> The following architectures are not in linux-next (and should be):
> 
> alpha		cris		frv
> h8300		m32r		m68knommu
> mips		mn10300		parisc
> um		v850		xtensa

mips, m32r, parisc and xtensa do have git trees.  The rest are mastered as
discrete patches in -mm.

Except for m68knommu, which pops unexpectedly out of the woodwork during
the merge window.  I've asked that this be altered ;)
