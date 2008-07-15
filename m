Return-Path: <linux-kernel-owner+w=401wt.eu-S1760812AbYGOMXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812AbYGOMXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbYGOMW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:22:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbYGOMW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:22:57 -0400
Date: Tue, 15 Jul 2008 08:22:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Chinner <david@fromorbit.com>, Lachlan McIlroy <lachlan@sgi.com>,
       Mikael Abrahamsson <swmike@swm.pp.se>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, linux-mm@kvack.org
Subject: Re: xfs bug in 2.6.26-rc9
Message-ID: <20080715122250.GA15744@infradead.org>
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <487B019B.9090401@sgi.com> <20080714121332.GX29319@disturbed> <200807151617.58329.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807151617.58329.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It would be easily possible to do, yes.

What happened to your plans to merge ->nopfn into ->fault?  Beeing
able to restart page based faults would be a logical fallout from that.
