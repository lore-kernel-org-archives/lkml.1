Return-Path: <linux-kernel-owner+w=401wt.eu-S1763161AbXGVSvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763161AbXGVSvl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 14:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759401AbXGVSv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 14:51:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56986 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760888AbXGVSv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 14:51:26 -0400
Date: Sun, 22 Jul 2007 11:50:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linus Nilsson <lajnold@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] Documentation: Fix a mispelt "probably" in
 SubmittingPatches.
In-Reply-To: <4e63727f0707210849n671122dbp74969594fc04f5c8@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0707221150110.3607@woody.linux-foundation.org>
References: <4e63727f0707210849n671122dbp74969594fc04f5c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 21 Jul 2007, Linus Nilsson wrote:
>
> Fix a typo in SubmittingPatches where "probably" was spelt "probabally".
> 
> Signed-off-by: Linus Nilsson <lajnold@gmail.com>

Your patches are whitespace-damaged.

It was easy to fix up in this case, but with anything slightly more 
complex, the patches would have been just ignored.

		Linus
