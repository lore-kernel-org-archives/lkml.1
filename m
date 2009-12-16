Return-Path: <linux-kernel-owner+w=401wt.eu-S1762624AbZLPVhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762624AbZLPVhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 16:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbZLPVhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 16:37:47 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:54389 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbZLPVhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 16:37:47 -0500
Date: Wed, 16 Dec 2009 15:36:32 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and
 cleanup
In-Reply-To: <alpine.DEB.2.00.0912160844440.8572@router.home>
Message-ID: <alpine.DEB.2.00.0912161536070.16113@router.home>
References: <20091214220320.665065925@quilx.com> <20091215170622.GA24739@csn.ul.ie> <alpine.DEB.2.00.0912160844440.8572@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With todays git tree I get a reject. Will rediff when rc1 is out.

