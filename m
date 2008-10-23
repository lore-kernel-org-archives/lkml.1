Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbYJWRq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbYJWRq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 13:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYJWRqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 13:46:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739AbYJWRqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:46:20 -0400
Date: Thu, 23 Oct 2008 10:46:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [git pull] PCI pull request #2 for 2.6.28
In-Reply-To: <200810221714.18723.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.2.00.0810231043560.3287@nehalem.linux-foundation.org>
References: <200810221714.18723.jbarnes@virtuousgeek.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Oct 2008, Jesse Barnes wrote:
> 
> A few more bits for 2.6.28, mainly hotplug related stuff so the risk should be
> pretty low.  There are a few good fixes in here though too: a build fix for
> some architectures due to the new ioremap_nocache usage in pci.h and a fix for
> a refcounting bug.

Pulled.

Ingo tells me that the ARI code is broken on his Nehalem, and that there's 
already a confirmed fix for it by Yu Zhao ("[PATCH] pci: fix ARI") but 
it's not in this series. 

Hmm? Status?

		Linus
