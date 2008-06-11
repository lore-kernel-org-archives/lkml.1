Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbYFKXUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbYFKXUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 19:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbYFKXU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 19:20:26 -0400
Received: from relay2.sgi.com ([192.48.171.30]:55331 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752927AbYFKXUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 19:20:25 -0400
Date: Wed, 11 Jun 2008 16:20:24 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <npiggin@suse.de>, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org
Subject: Re: [patch 7/7] powerpc: lockless get_user_pages_fast
In-Reply-To: <20080610230622.abed7b55.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0806111619330.23868@schroedinger.engr.sgi.com>
References: <20080605094300.295184000@nick.local0.net>
 <20080605094826.128415000@nick.local0.net> <Pine.LNX.4.64.0806101159110.17798@schroedinger.engr.sgi.com>
 <20080611031822.GA8228@wotan.suse.de> <Pine.LNX.4.64.0806102138380.19967@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0806102141010.19967@schroedinger.engr.sgi.com>
 <20080611044902.GB11545@wotan.suse.de> <20080610230622.abed7b55.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Andrew Morton wrote:

> hasn't been made.  Carrying both versions was supposed to be a
> short-term transitional thing :(

The whatever defrag patchset includes a patch to make SLAB
experimental. So one step further.


