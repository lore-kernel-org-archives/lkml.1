Return-Path: <linux-kernel-owner+w=401wt.eu-S933782AbYDVXUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782AbYDVXUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761202AbYDVXUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:20:36 -0400
Received: from relay1.sgi.com ([192.48.171.29]:52536 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760918AbYDVXUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:20:35 -0400
Date: Tue, 22 Apr 2008 16:20:35 -0700 (PDT)
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
In-Reply-To: <20080422223545.GP24536@duo.random>
Message-ID: <Pine.LNX.4.64.0804221619540.4996@schroedinger.engr.sgi.com>
References: <ea87c15371b1bd49380c.1208872277@duo.random>
 <Pine.LNX.4.64.0804221315160.3640@schroedinger.engr.sgi.com>
 <20080422223545.GP24536@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008, Andrea Arcangeli wrote:

> I'll send an update in any case to Andrew way before Saturday so
> hopefully we'll finally get mmu-notifiers-core merged before next
> week. Also I'm not updating my mmu-notifier-core patch anymore except
> for strict bugfixes so don't worry about any more cosmetical bugs
> being introduced while optimizing the code like it happened this time.

I guess I have to prepare another patchset then?

