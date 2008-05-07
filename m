Return-Path: <linux-kernel-owner+w=401wt.eu-S1764683AbYEGR4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764683AbYEGR4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbYEGR4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:56:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755111AbYEGR42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:56:28 -0400
Date: Wed, 7 May 2008 13:46:29 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrea Arcangeli <andrea@qumranet.com>
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
Subject: Re: [PATCH 05 of 11] unmap vmas tlb flushing
Message-ID: <20080507134629.0dcfd4a1@bree.surriel.com>
In-Reply-To: <20bc6a66a86ef6bd6091.1210170955@duo.random>
References: <patchbomb.1210170950@duo.random>
	<20bc6a66a86ef6bd6091.1210170955@duo.random>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 16:35:55 +0200
Andrea Arcangeli <andrea@qumranet.com> wrote:

> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
