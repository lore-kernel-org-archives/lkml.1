Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbYFCRfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbYFCRfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYFCRfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:35:05 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:44704
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbYFCRfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:35:04 -0400
Date: Tue, 3 Jun 2008 19:35:02 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH 001/001] mmu-notifier-core v17
Message-ID: <20080603173502.GR8158@duo.random>
References: <20080509193230.GH7710@duo.random> <alpine.LFD.1.10.0806030909030.3473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806030909030.3473@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 09:26:05AM -0700, Linus Torvalds wrote:
> I'd obviously want to see ack's by people like Andrew, Hugh and Nick, but 
> as far as I am concerned, if you just do the trivial cleanup/split, you 

I'll do all cleanups/splits very shortly and submit a v18 with 3
patches, all good, thanks a lot!
