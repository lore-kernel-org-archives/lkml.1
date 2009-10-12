Return-Path: <linux-kernel-owner+w=401wt.eu-S932529AbZJLPDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbZJLPDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757009AbZJLPDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:03:18 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:58817 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756683AbZJLPDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:03:17 -0400
Date: Mon, 12 Oct 2009 10:55:43 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Mel Gorman <mel@csn.ul.ie>, David Rientjes <rientjes@google.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
  operations in the hotpaths
In-Reply-To: <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0910121055160.7932@gentwo.org>
References: <20091007211024.442168959@gentwo.org>  <20091007211053.378634196@gentwo.org> <4AD307A5.105@kernel.org> <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Pekka Enberg wrote:

> The patch looks sane to me but the changelog contains no relevant
> numbers on performance. I am fine with the patch going in -percpu but
> the patch probably needs some more beating performance-wise before it
> can go into .33. I'm CC'ing some more people who are known to do SLAB
> performance testing just in case they're interested in looking at the
> patch. In any case,

I am warming up my synthetic in kernel tests right now. Hope I have
something by tomorrow.

