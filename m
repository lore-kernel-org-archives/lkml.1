Return-Path: <linux-kernel-owner+w=401wt.eu-S1763291AbYDNT6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763291AbYDNT6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762515AbYDNT56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:57:58 -0400
Received: from relay2.sgi.com ([192.48.171.30]:57115 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762492AbYDNT55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:57:57 -0400
Date: Mon, 14 Apr 2008 12:57:56 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: akpm@linux-foundation.org, Nick Piggin <npiggin@suse.de>,
       Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 3 of 9] Moves all mmu notifier methods outside the PT
 lock (first and not last
In-Reply-To: <33de2e17d0f567051583.1207669446@duo.random>
Message-ID: <Pine.LNX.4.64.0804141257160.7803@schroedinger.engr.sgi.com>
References: <33de2e17d0f567051583.1207669446@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure why this patch is not merged into 2 of 9. Same comment as last 
round.



