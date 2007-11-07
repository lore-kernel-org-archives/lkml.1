Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbXKGWtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbXKGWtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbXKGWtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:49:07 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:55242 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752816AbXKGWtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:49:06 -0500
Date: Wed, 7 Nov 2007 23:48:08 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] r8169 fix regression on ASUS motherboards (updated)
Message-ID: <20071107224808.GC15367@electric-eye.fr.zoreil.com>
References: <4731E2AB.5080703@rtr.ca> <4731FDB7.8010505@rtr.ca> <20071107220455.GA15367@electric-eye.fr.zoreil.com> <47323A69.5050206@rtr.ca> <47323B6B.9000909@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47323B6B.9000909@rtr.ca>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord <lkml@rtr.ca> :
> Mark Lord wrote:
> >Francois Romieu wrote:
> >..
> >>I am not convinced, the broken ones include some RTL_GIGA_MAC_VER_12
> >>too, namely XID = 0x38000000.
> ..
> 
> Here is the updated patch for both VER_11 and VER_12.
> Let's get this in, as the driver has been broken for weeks now.

I have not been waiting for you and I am not interested in your
controversy.

I'll find the offending commit and revert it. It is that simple.

-- 
Ueimor
