Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbXKCR7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbXKCR7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 13:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbXKCR7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 13:59:42 -0400
Received: from 1wt.eu ([62.212.114.60]:3669 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbXKCR7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 13:59:42 -0400
Date: Sat, 3 Nov 2007 18:59:26 +0100
From: Willy Tarreau <w@1wt.eu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-stable@vger.kernel.org
Subject: Re: [PATCH 1/2] slub: fix leakage
Message-ID: <20071103175926.GB9432@1wt.eu>
References: <Pine.LNX.4.64.0711031708040.10266@blonde.wat.veritas.com> <20071103173807.GB1045@1wt.eu> <Pine.LNX.4.64.0711031750420.11221@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711031750420.11221@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2007 at 05:55:50PM +0000, Hugh Dickins wrote:
> On Sat, 3 Nov 2007, Willy Tarreau wrote:
> > On Sat, Nov 03, 2007 at 05:10:54PM +0000, Hugh Dickins wrote:
> > > I recommend this for 2.6.24-rc2 and 2.6.23-stable.
> > 
> > Hugh, you should also have CC'd linux-stable for this, otherwise there's
> > a risk that the patch remains unnoticed by the stable team (CC'd).
> 
> That was intentional, actually: I thought Christoph ought to have
> a say in it first.  Then he or I would alert the stable team.

OK, it's clearer then. Sorry for the noise.

Willy

