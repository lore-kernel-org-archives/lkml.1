Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab0CIPMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 10:12:06 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:59710 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab0CIPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 10:12:04 -0500
Date: Tue, 9 Mar 2010 09:10:52 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: mm: Do not iterate over NR_CPUS in __zone_pcp_update()
In-Reply-To: <4B95AD17.2030106@kernel.org>
Message-ID: <alpine.DEB.2.00.1003090910200.28897@router.home>
References: <alpine.LFD.2.00.1003081018070.22855@localhost.localdomain> <84144f021003080529w1b20c08dmf6871bd46381bc71@mail.gmail.com> <4B95AD17.2030106@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Mar 2010, Tejun Heo wrote:

> Yeap, that's buggy.
>
> Acked-by: Tejun Heo <tj@kernel.org>
>
> I suppose this would go through the mm tree?

As you said: Its a bug so it needs to be applied to upstream.

