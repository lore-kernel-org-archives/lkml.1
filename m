Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbZDGCeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbZDGCeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZDGCeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:34:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863AbZDGCeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:34:01 -0400
Date: Mon, 6 Apr 2009 19:32:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Miller <davem@davemloft.net>
cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
In-Reply-To: <20090406.190745.263215778.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0904061931160.4010@localhost.localdomain>
References: <20090406.175752.236260059.davem@davemloft.net> <alpine.LFD.2.00.0904061824410.4010@localhost.localdomain> <20090406.190745.263215778.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, David Miller wrote:

> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Mon, 6 Apr 2009 18:25:31 -0700 (PDT)
> > 
> > 
> > The sky2 driver is buggered (by the previous pull, I presume). Some PCI 
> > interaction. NULL pointer dereference at boot.
> 
> Fixed in the PCI tree, have you pulled that one yet?

Nobody has even _asked_ me to pull.

What's the point of having fixes available if they aren't merged?

		Linus
