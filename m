Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbZBQQKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbZBQQKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZBQQKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:10:04 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:43914 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751499AbZBQQKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:10:03 -0500
Date: Tue, 17 Feb 2009 11:01:30 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 1/8] slab: introduce kzfree()
In-Reply-To: <1234885876.11511.3.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0902171100520.29986@qirst.com>
References: <20090216142926.440561506@cmpxchg.org>  <20090216144725.572446535@cmpxchg.org> <20090216152751.GA27520@cmpxchg.org>  <alpine.DEB.1.10.0902171007010.19685@qirst.com> <1234885876.11511.3.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009, Pekka Enberg wrote:

> Johannes, I suppose it would make sense to resend the series to Andrew
> with all the updates?

Ah now when looking at the whole set I see the point.

