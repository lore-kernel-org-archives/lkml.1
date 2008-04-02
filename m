Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbYDBK7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbYDBK7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 06:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbYDBK7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 06:59:33 -0400
Received: from relay2.sgi.com ([192.48.171.30]:58823 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752530AbYDBK7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:59:32 -0400
Date: Wed, 2 Apr 2008 05:59:25 -0500
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, Hugh Dickins <hugh@veritas.com>,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 1/9] EMM Notifier: The notifier calls
Message-ID: <20080402105925.GC22493@sgi.com>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com> <20080402064952.GF19189@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402064952.GF19189@duo.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 08:49:52AM +0200, Andrea Arcangeli wrote:
> Most other patches will apply cleanly on top of my coming mmu
> notifiers #v10 that I hope will go in -mm.
> 
> For #v10 the only two left open issues to discuss are:

Does your v10 allow sleeping inside the callbacks?

Thanks,
Robin
