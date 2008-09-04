Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYIDHtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYIDHtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 03:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYIDHsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 03:48:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39959 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbYIDHst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 03:48:49 -0400
Message-ID: <48BF92D7.8050304@garzik.org>
Date: Thu, 04 Sep 2008 03:48:39 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: David Fries <david@fries.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] ne.c fix for hibernate and rmmod oops fix
References: <20080904030212.GA23493@spacedout.fries.net>
In-Reply-To: <20080904030212.GA23493@spacedout.fries.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Fries wrote:
> Andrew Morton, 
> 
> This patch is ready to be merged.
> 
> 
> 
> This ne2000 and the previous cr4 problem found when enabling suspend to
> disk on my i486 with a PnP ISA NE2000 and Creative SB Live in the
> trunk of my car.  It is providing in car podcast entertainment.  Must
> be a unique setup.

Please send a correct patch format.  The comments quoted above are all 
that appears when I run the official patch import tools ('git am').

It should be a simple matter of making sure your patch email body starts 
with "Removing the module would cause a kernel oops as 
platform_driver_probe" as described in Documentation/SubmittingPatches.

	Jeff


