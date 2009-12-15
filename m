Return-Path: <linux-kernel-owner+w=401wt.eu-S1751574AbZLOGhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbZLOGhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 01:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbZLOGht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 01:37:49 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40667 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZLOGhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 01:37:48 -0500
Subject: Re: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and
 cleanup
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <20091214220320.665065925@quilx.com>
References: <20091214220320.665065925@quilx.com>
Date: Tue, 15 Dec 2009 08:37:46 +0200
Message-Id: <1260859066.4770.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 16:03 -0600, Christoph Lameter wrote:
> Leftovers from the earlier patchset. Mostly applications of per cpu counters
> to core components.

I can pick up the SLUB patches. Is that OK with you Tejun?

