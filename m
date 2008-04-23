Return-Path: <linux-kernel-owner+w=401wt.eu-S933976AbYDWAbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976AbYDWAbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 20:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757977AbYDWAbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 20:31:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48971 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754173AbYDWAbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 20:31:42 -0400
Date: Tue, 22 Apr 2008 19:31:40 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 00 of 12] mmu notifier #v13
Message-ID: <20080423003140.GB32618@sgi.com>
References: <patchbomb.1208872276@duo.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1208872276@duo.random>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 03:51:16PM +0200, Andrea Arcangeli wrote:
> Hello,
> 
> This is the latest and greatest version of the mmu notifier patch #v13.
> 

FWIW, I have updated the GRU driver to use this patch (plus the fixeups).
No problems. AFAICT, everything works.


--- jack
