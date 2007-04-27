Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbXD0Rq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbXD0Rq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbXD0Rq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:46:58 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754211AbXD0Rq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:46:56 -0400
Date: Fri, 27 Apr 2007 10:46:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
cc: Peter Williams <pwil3058@bigpond.net.au>, jgarzik@pobox.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux-2.6.21 hangs during post boot initialization phase
In-Reply-To: <20070427171150.GF19017@hmsreliant.homelinux.net>
Message-ID: <alpine.LFD.0.98.0704271045180.9964@woody.linux-foundation.org>
References: <463166C2.6060106@bigpond.net.au>
 <alpine.LFD.0.98.0704262035410.9964@woody.linux-foundation.org>
 <46319297.905@bigpond.net.au> <20070427122247.GA19017@hmsreliant.homelinux.net>
 <4632088C.8000509@bigpond.net.au>
 <20070427171150.GF19017@hmsreliant.homelinux.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Apr 2007, Neil Horman wrote:
> 
> Damn, This is what happens when I try to do things too quickly.  I missed one
> spot in my last patch where I replaced skb with rx_skb [...]

Jeff, I'm going to assume I get all these through your normal network 
driver tree.

So this is just a note to say that I'm currently ignoring both the 
previous patch and this fix on top of it ;)

		Linus
