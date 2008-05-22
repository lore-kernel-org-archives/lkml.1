Return-Path: <linux-kernel-owner+w=401wt.eu-S1762064AbYEVF4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762064AbYEVF4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 01:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbYEVF4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 01:56:41 -0400
Received: from ozlabs.org ([203.10.76.45]:32885 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075AbYEVF4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 01:56:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 18/57] iTCO: unlocked_ioctl, coding style and cleanup
Date: Thu, 22 May 2008 15:56:26 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       wim@iguana.be, Stephen Rothwell <sfr@canb.auug.org.au>
References: <20080519124659.31722.51847.stgit@core> <200805211426.16234.rusty@rustcorp.com.au> <20080521102922.4f0c405d@core>
In-Reply-To: <20080521102922.4f0c405d@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805221556.27390.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 May 2008 19:29:22 Alan Cox wrote:
> > I've been pulling out s/down_trylock/down_nowait/ patches which effect
> > others' changes.  Those patches get moved to the end of my queue, and
> > I'll revisit them before an actual merge with Linus.
>
> The watchdog drivers all got the semaphores removed in the patch set I
> did so you can dump that bit.

Done, thanks.  Are you in linux-next yet?  Stephen is pretty good at telling 
me about this kind of stuff...

Thanks,
Rusty.
