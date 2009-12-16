Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbZLPOqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbZLPOqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbZLPOqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:46:14 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:56112 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZLPOqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:46:13 -0500
Date: Wed, 16 Dec 2009 08:44:57 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and
 cleanup
In-Reply-To: <20091215170622.GA24739@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0912160844440.8572@router.home>
References: <20091214220320.665065925@quilx.com> <20091215170622.GA24739@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009, Mel Gorman wrote:

> What kernel are these patches based on? They do not cleanly apply and
> when fixed up, they do not build against 2.6.32.

Upstream. Linus tree.

