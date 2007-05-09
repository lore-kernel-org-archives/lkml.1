Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbXEIK5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbXEIK5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbXEIK5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:57:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:45972 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbXEIK5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:57:06 -0400
Date: Wed, 9 May 2007 12:54:31 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       rusty@rustcorp.com.au, ak@suse.de, Rene Herman <rene.herman@gmail.com>
Subject: Re: [patch 8/9] lguest: the block driver
Message-ID: <20070509105431.GT4163@kernel.dk>
References: <200705090951.l499pdsc020409@shell0.pdx.osdl.net> <84144f020705090322jc37884drc31b97879648d09@mail.gmail.com> <20070509102933.GR4163@kernel.dk> <Pine.LNX.4.64.0705091345400.16351@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705091345400.16351@sbz-30.cs.Helsinki.FI>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09 2007, Pekka J Enberg wrote:
> On Wed, 9 May 2007, Jens Axboe wrote:
> > Lets do it after it is merged, as not to create a hold-up point for
> > lguest. Once it's in, I'll fix it up.
> 
> Ok. Seems pointless, though, as it's only a matter of:

Yes I'm very well aware of that, my point is just that I'll do it once
lguest is merged since then

a) it has a user, and
b) I don't want lguest to wait for me to get that update pulled

Can we please let this rest?

-- 
Jens Axboe

