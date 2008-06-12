Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbYFLKmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbYFLKmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756531AbYFLKmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:42:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34240 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441AbYFLKmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:42:02 -0400
Message-ID: <4850FD75.8020403@firstfloor.org>
Date: Thu, 12 Jun 2008 12:41:57 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Nadia Derbey <Nadia.Derbey@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: repeatable slab corruption with LTP msgctl08
References: <20080611221324.42270ef2.akpm@linux-foundation.org>	<20080611233449.08e6eaa0.akpm@linux-foundation.org>	<20080612010200.106df621.akpm@linux-foundation.org>	<20080612011537.6146c41d.akpm@linux-foundation.org>	<87mylrnj84.fsf@basil.nowhere.org> <20080612032442.930e62e4.akpm@linux-foundation.org>
In-Reply-To: <20080612032442.930e62e4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> But it hasn't crashed after 57 minutes.
> 
> I don't think that is how we should fix this bug ;)

This means it doesn't corrupt other slabs. Maybe only its own?

-Andi

