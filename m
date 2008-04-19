Return-Path: <linux-kernel-owner+w=401wt.eu-S1761971AbYDSPCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761971AbYDSPCT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYDSPCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:02:07 -0400
Received: from vena.lwn.net ([206.168.112.25]:33323 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbYDSPCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:02:06 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] /dev/vring: simple userspace-kernel ringbuffer interface. 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Fri, 18 Apr 2008 11:59:59 PDT."
             <20080418115959.6b8fdfa7.akpm@linux-foundation.org> 
Date: Sat, 19 Apr 2008 09:02:04 -0600
Message-ID: <8793.1208617324@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I think it would be good to plonk the proposed interface on the table
> and have a poke at it.  Is it compat-safe?  Is it extensible in a
> backward-compatible fashion?  Are there future-safe changes we should make
> to it?  Can Michael Kerrisk understand, review and document it?  etc.
> 
> You know what I'm saying ;)  What is the proposed interface?

So, I'm not Michael, but I *did* make an attempt to document this
interface - user and kernel sides - so that it could be more easily
understood:

	http://lwn.net/Articles/276856/

That was the previous posting, but a quick look suggests it hasn't
changed *that* much in this round.

jon
