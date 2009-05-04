Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbZEDLIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbZEDLIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 07:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZEDLIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 07:08:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbZEDLIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 07:08:43 -0400
Date: Mon, 4 May 2009 07:08:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Magnus Damm <magnus.damm@gmail.com>, linux-media@vger.kernel.org,
       Hans Verkuil <hverkuil@xs4all.nl>, Paul Mundt <lethal@linux-sh.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] mm: introduce follow_pfn()
Message-ID: <20090504110841.GA19646@infradead.org>
References: <20090501181449.GA8912@cmpxchg.org> <1241430874-12667-3-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241430874-12667-3-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 11:54:34AM +0200, Johannes Weiner wrote:
> Analoguous to follow_phys(), add a helper that looks up the PFN
> instead.  It also only allows IO mappings or PFN mappings.

A kerneldoc describing what it does and the limitations would be
extremly helpful.

