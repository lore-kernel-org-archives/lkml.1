Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbZFQVC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbZFQVC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 17:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZFQVCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 17:02:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342AbZFQVCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 17:02:49 -0400
Date: Wed, 17 Jun 2009 14:02:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Wilcox <matthew@wil.cx>
cc: Matthew Wilcox <willy@linux.intel.com>, jbarnes@virtuousgeek.org,
       andrew.patterson@hp.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ia64: Fix resource assignment for root busses
In-Reply-To: <20090617205905.GX19977@parisc-linux.org>
Message-ID: <alpine.LFD.2.01.0906171402050.16802@localhost.localdomain>
References: <1245270816-11755-1-git-send-email-willy@linux.intel.com> <1245270816-11755-5-git-send-email-willy@linux.intel.com> <alpine.LFD.2.01.0906171356040.16802@localhost.localdomain> <20090617205905.GX19977@parisc-linux.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, Matthew Wilcox wrote:

> On Wed, Jun 17, 2009 at 01:56:39PM -0700, Linus Torvalds wrote:
> > 
> > So I assume this "Tested-by:" means that Andrew confirmed that this 
> > actually fixes the nesting? I wasn't cc'd on that, so I'm just checking..
> 
> Yes, he says it fixes the nesting problem, and as a result hotplug now works.

Ok, I'll take the whole series. Thanks for chasing this down,

		Linus
