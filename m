Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbYFQIlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbYFQIlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 04:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbYFQIk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 04:40:56 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27677 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbYFQIk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 04:40:56 -0400
Date: Tue, 17 Jun 2008 10:40:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/5] xen/blkfront: Make sure we don't use bounce buffers,  we don't need them.
Message-ID: <20080617084053.GF20851@kernel.dk>
References: <4856DED4.9030402@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4856DED4.9030402@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16 2008, Jeremy Fitzhardinge wrote:
> From: Ian Campbell <ian.campbell@xensource.com>
> 
> [ linux-2.6.18-xen changeset 667228bf8fc5 ]
> 
> Signed-off-by: Ian Campbell <ian.campbell@xensource.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

All 5 patches look fine to me, I've queued them for 2.6.27.

-- 
Jens Axboe

