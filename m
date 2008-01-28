Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYA1UQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYA1UQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYA1UQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:16:42 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45990 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751454AbYA1UQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:16:42 -0500
Date: Mon, 28 Jan 2008 12:16:40 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Izik Eidus <izike@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 0/4] [RFC] MMU Notifiers V1
In-Reply-To: <20080128194005.GE7233@v2.random>
Message-ID: <Pine.LNX.4.64.0801281216100.8965@schroedinger.engr.sgi.com>
References: <20080125055606.102986685@sgi.com> <20080125114229.GA7454@v2.random>
 <479DFE7F.9030305@qumranet.com> <20080128172521.GC7233@v2.random>
 <Pine.LNX.4.64.0801281103030.14003@schroedinger.engr.sgi.com>
 <20080128194005.GE7233@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008, Andrea Arcangeli wrote:

> With regard to the synchronize_rcu troubles they also be left to the
> notifier-user to solve. Certainly having the synchronize_rcu like in

Ahh. Ok.
