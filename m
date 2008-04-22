Return-Path: <linux-kernel-owner+w=401wt.eu-S1760615AbYDVU2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615AbYDVU2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbYDVU21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:28:27 -0400
Received: from relay2.sgi.com ([192.48.171.30]:48079 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750892AbYDVU20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:28:26 -0400
Date: Tue, 22 Apr 2008 13:28:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Jack Steiner <steiner@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 00 of 12] mmu notifier #v13
In-Reply-To: <20080422184335.GN24536@duo.random>
Message-ID: <Pine.LNX.4.64.0804221327130.3640@schroedinger.engr.sgi.com>
References: <patchbomb.1208872276@duo.random> <20080422182213.GS22493@sgi.com>
 <20080422184335.GN24536@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008, Andrea Arcangeli wrote:

> My patch order and API backward compatible extension over the patchset
> is done to allow 2.6.26 to fully support KVM/GRU and 2.6.27 to support
> XPMEM as well. KVM/GRU won't notice any difference once the support
> for XPMEM is added, but even if the API would completely change in
> 2.6.27, that's still better than no functionality at all in 2.6.26.

Please redo the patchset with the right order. To my knowledge there is no 
chance of this getting merged for 2.6.26.

