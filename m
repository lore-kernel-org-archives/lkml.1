Return-Path: <linux-kernel-owner+w=401wt.eu-S1756417AbYFKEl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbYFKEl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 00:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYFKElq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 00:41:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37975 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751137AbYFKElq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 00:41:46 -0400
Date: Tue, 10 Jun 2008 21:41:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, paulus@samba.org
Subject: Re: [patch 7/7] powerpc: lockless get_user_pages_fast
In-Reply-To: <Pine.LNX.4.64.0806102138380.19967@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0806102141010.19967@schroedinger.engr.sgi.com>
References: <20080605094300.295184000@nick.local0.net>
 <20080605094826.128415000@nick.local0.net> <Pine.LNX.4.64.0806101159110.17798@schroedinger.engr.sgi.com>
 <20080611031822.GA8228@wotan.suse.de> <Pine.LNX.4.64.0806102138380.19967@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And yes slab defrag is part of linux-next. So it would break.

