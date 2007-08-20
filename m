Return-Path: <linux-kernel-owner+w=401wt.eu-S1757743AbXHTS6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743AbXHTS6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 14:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbXHTS57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 14:57:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40529 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752861AbXHTS56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 14:57:58 -0400
Date: Mon, 20 Aug 2007 11:57:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Joe Perches <joe@perches.com>
cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org
Subject: Re: [PATCH 5/5] mm/... convert #include "linux/..." to #include
 <linux/...>
In-Reply-To: <1187635766.5963.3.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708201157320.28863@schroedinger.engr.sgi.com>
References: <1187561983.4200.145.camel@localhost> 
 <Pine.LNX.4.64.0708201106230.25248@schroedinger.engr.sgi.com>
 <1187635766.5963.3.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007, Joe Perches wrote:

> Maybe.  I think it's just a simple error.
> 
> mm/slab.c has 2 other includes of
> 
> 	#include <linux/kmalloc_sizes.h>
> 
> cheers, Joe

Ahh. ok.

Then

Acked-by: Christoph Lameter <clameter@sgi.com>

