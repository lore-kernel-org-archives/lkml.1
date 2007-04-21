Return-Path: <linux-kernel-owner+w=401wt.eu-S1751187AbXDUPkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbXDUPkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 11:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbXDUPkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 11:40:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52668 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750782AbXDUPko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 11:40:44 -0400
Date: Sat, 21 Apr 2007 08:40:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ethan Solomita <solo@google.com>
cc: akpm@osdl.org, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC 0/8] Cpuset aware writeback
In-Reply-To: <4629C81D.8050606@google.com>
Message-ID: <Pine.LNX.4.64.0704210837150.17690@schroedinger.engr.sgi.com>
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
 <45C2960B.9070907@google.com> <Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com>
 <46019F67.3010300@google.com> <Pine.LNX.4.64.0703211428430.4832@schroedinger.engr.sgi.com>
 <4626CEDA.7050608@google.com> <Pine.LNX.4.64.0704181948260.8743@schroedinger.engr.sgi.com>
 <46296ACD.3020402@google.com> <Pine.LNX.4.64.0704201840200.13607@schroedinger.engr.sgi.com>
 <4629C81D.8050606@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Apr 2007, Ethan Solomita wrote:

>    Exactly -- your patch should be consistent and do it the same way as
> whatever your patch is built against. Your patch is built against a kernel
> that subtracts off highmem. "Do it..." are you handing off the patch and are
> done with it?

Yes as said before the patch is not finished. As I told you I have other 
things to do right now. It is not high on my agenda and some other 
developers have shown an interest. Feel free to take over the patch.
