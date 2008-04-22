Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbYDVUYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbYDVUYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbYDVUYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:24:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39430 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754881AbYDVUYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:24:22 -0400
Date: Tue, 22 Apr 2008 13:24:21 -0700 (PDT)
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
Subject: Re: [PATCH 04 of 12] Moves all mmu notifier methods outside the PT
 lock (first and not last
In-Reply-To: <ac9bb1fb3de2aa5d2721.1208872280@duo.random>
Message-ID: <Pine.LNX.4.64.0804221323510.3640@schroedinger.engr.sgi.com>
References: <ac9bb1fb3de2aa5d2721.1208872280@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reverts a part of an earlier patch. Why isnt this merged into 1 of 12?


