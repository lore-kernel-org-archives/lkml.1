Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYEGFgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYEGFgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 01:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYEGFfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 01:35:48 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:43001 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbYEGFfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 01:35:46 -0400
Date: Wed, 7 May 2008 06:30:05 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
In-Reply-To: <b6a2187b0805062140i2546a1a8pc3fa65227a9873ab@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805070625200.3983@blonde.site>
References: <b6a2187b0805051806v25fa1272xb08e0b70b9c3408@mail.gmail.com> 
 <20080506124946.GA2146@elte.hu>  <Pine.LNX.4.64.0805061435510.32567@blonde.site>
  <alpine.LFD.1.10.0805061138580.32269@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0805062043580.11647@blonde.site>
 <b6a2187b0805062140i2546a1a8pc3fa65227a9873ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Jeff Chua wrote:
> 
> Thanks for the patch. It's in Linus's git now and I just booted 2 Dell

Thanks for reporting and reporting back: from your contentment ...

> 2950 and both are no showing the errors.
                      ^ 
... I'll assume the missing letter is "t" rather than "w" ;)

Hugh
