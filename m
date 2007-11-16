Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbXKPCTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbXKPCTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 21:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbXKPCTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 21:19:40 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48011 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752232AbXKPCTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 21:19:39 -0500
Date: Thu, 15 Nov 2007 18:19:37 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: corbet@lwn.net, andi@firstfloor.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <20071115.140305.137877909.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711151816170.31691@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711132023290.7631@schroedinger.engr.sgi.com>
 <20071113.215306.78239549.davem@davemloft.net>
 <Pine.LNX.4.64.0711151045060.28051@schroedinger.engr.sgi.com>
 <20071115.140305.137877909.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, David Miller wrote:

> Well, the first version of the patch set, the one I tested, did
> require a lot of BSS space.  And that's the one they are writing
> about.

I am running the same version that you also ran. The problem is that you 
did not configure the stuff properly for your box and I did not include a 
configuration for sparc64 since I did not know how it needed to be 
configured for sparc64. You ignored the patch for sparc64 that I provided 
to correct the problem.




