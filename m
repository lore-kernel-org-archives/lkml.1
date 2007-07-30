Return-Path: <linux-kernel-owner+w=401wt.eu-S967574AbXG3SDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967574AbXG3SDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965772AbXG3SDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:03:38 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:50726 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762564AbXG3SDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:03:37 -0400
Date: Mon, 30 Jul 2007 20:03:01 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: bug in slab.c
Message-ID: <20070730180301.GG1678@pengutronix.de>
References: <20070729073739.GD1678@pengutronix.de> <20070730001604.d58dca0a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070730001604.d58dca0a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 12:16:04AM -0700, Andrew Morton wrote:
> > My Dell Latitude D520 just dies with this BUG:
>
> Reproducible, I assume.

No, happened only one time.

> Have you tried testing a kernel which doesn't have those drivers?
>
> (It'd be a clever little driver to cause that BUG though)

Yup :-) It didn't happen again in the meantime, but anyway. I'll keep
you informed.

Robert
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

