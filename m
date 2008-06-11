Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbYFKEtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbYFKEtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 00:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYFKEtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 00:49:05 -0400
Received: from mx1.suse.de ([195.135.220.2]:57925 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbYFKEtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 00:49:04 -0400
Date: Wed, 11 Jun 2008 06:49:02 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org
Subject: Re: [patch 7/7] powerpc: lockless get_user_pages_fast
Message-ID: <20080611044902.GB11545@wotan.suse.de>
References: <20080605094300.295184000@nick.local0.net> <20080605094826.128415000@nick.local0.net> <Pine.LNX.4.64.0806101159110.17798@schroedinger.engr.sgi.com> <20080611031822.GA8228@wotan.suse.de> <Pine.LNX.4.64.0806102138380.19967@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0806102141010.19967@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806102141010.19967@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 09:41:33PM -0700, Christoph Lameter wrote:
> And yes slab defrag is part of linux-next. So it would break.

Can memory management patches go though mm/? I dislike the cowboy
method of merging things that some other subsystems have adopted :)
