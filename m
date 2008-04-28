Return-Path: <linux-kernel-owner+w=401wt.eu-S1765602AbYD1GK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765602AbYD1GK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbYD1GKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:10:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38258 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbYD1GKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:10:45 -0400
Date: Mon, 28 Apr 2008 02:10:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
Message-ID: <20080428061040.GA17554@infradead.org>
References: <1209329485.3801.46.camel@localhost.localdomain> <20080427214837.GA11631@elte.hu> <1209333959.3801.67.camel@localhost.localdomain> <20080427231809.GA13848@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427231809.GA13848@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 01:18:09AM +0200, Ingo Molnar wrote:
> ... but the PAT patchset was all around lkml. The ioremap change was 
> trivial, went into v2.6.25 and was discussed on lkml:
> 
>   http://lkml.org/lkml/2008/1/25/287

lkml is a hell-hole with a signal/noise ratio worse than slashdot.  Any
chance you could create a linux-x86 list for x86 specific changes so
that a focussed review and discussion can happen?

