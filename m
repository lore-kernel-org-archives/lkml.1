Return-Path: <linux-kernel-owner+w=401wt.eu-S1762748AbYDVUZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762748AbYDVUZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbYDVUZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:25:11 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51524 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753267AbYDVUZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:25:10 -0400
Date: Tue, 22 Apr 2008 13:25:09 -0700 (PDT)
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
Subject: Re: [PATCH 05 of 12] Move the tlb flushing into free_pgtables. The
 conversion of the locks
In-Reply-To: <ee8c0644d5f67c1ef591.1208872281@duo.random>
Message-ID: <Pine.LNX.4.64.0804221324460.3640@schroedinger.engr.sgi.com>
References: <ee8c0644d5f67c1ef591.1208872281@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why are the subjects all screwed up? They are the first line of the 
description instead of the subject line of my patches.


