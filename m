Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbXKCTye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbXKCTye (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 15:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757030AbXKCTy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 15:54:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50872 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756287AbXKCTy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 15:54:26 -0400
Date: Sat, 3 Nov 2007 12:54:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: =?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?= <oliver.pntr@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
In-Reply-To: <Pine.LNX.4.64.0711031950300.17078@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0711031253580.6080@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com>
 <6101e8c40711031027x3f946b28p324dadeab7c1b2c3@mail.gmail.com>
 <Pine.LNX.4.64.0711031741160.10953@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031847450.13845@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031935510.15611@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0711031247250.5828@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711031950300.17078@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2007, Hugh Dickins wrote:

> On Sat, 3 Nov 2007, Christoph Lameter wrote:
> > On Sat, 3 Nov 2007, Hugh Dickins wrote:
> > 
> > > Later Christoph noticed that I'm not handling the SlabDebug case right.
> > > So stable should ignore my patch, and he will come up with another.
> > 
> > Hmmm? I thought you wanted to test the patch provided?
> 
> Yes.  Sounds like you see a contradiction there - I don't see it.

Maybe language issues. I read this as meaning that there is no fix 
available yet.
 
