Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbYDWSP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbYDWSP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbYDWSPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:15:20 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54075 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755434AbYDWSPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:15:18 -0400
Date: Wed, 23 Apr 2008 11:15:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
In-Reply-To: <20080423162629.GB24536@duo.random>
Message-ID: <Pine.LNX.4.64.0804231110030.12373@schroedinger.engr.sgi.com>
References: <ea87c15371b1bd49380c.1208872277@duo.random>
 <Pine.LNX.4.64.0804221315160.3640@schroedinger.engr.sgi.com>
 <20080422223545.GP24536@duo.random> <Pine.LNX.4.64.0804221619540.4996@schroedinger.engr.sgi.com>
 <20080423162629.GB24536@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008, Andrea Arcangeli wrote:

> On Tue, Apr 22, 2008 at 04:20:35PM -0700, Christoph Lameter wrote:
> > I guess I have to prepare another patchset then?
> 
> If you want to embarrass yourself three time in a row go ahead ;). I
> thought two failed takeovers was enough.

Takeover? I'd be happy if I would not have to deal with this issue.

These  patches were necessary because you were not listening to 
feedback plus there is the issue that your patchsets were not easy to 
review or diff against. I had to merge several patches to get to a useful 
patch. You have always picked up lots of stuff from my patchsets. Lots of 
work that could have been avoided by proper patchsets in the first place.
