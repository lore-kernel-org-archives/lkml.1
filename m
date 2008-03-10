Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYCJGK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYCJGK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 02:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYCJGKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 02:10:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49430 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbYCJGKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 02:10:20 -0400
Date: Mon, 10 Mar 2008 02:10:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: Chris Knadle <Chris.Knadle@coredump.us>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, hch@infradead.org
Subject: Re: assfail during unmount xfs 2.6.24.3 [from 2.6.24.y git]
Message-ID: <20080310061013.GA3496@infradead.org>
References: <200803062329.10486.Chris.Knadle@coredump.us> <20080307224645.GW155259@sgi.com> <200803081555.11695.Chris.Knadle@coredump.us> <20080309221858.GS155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080309221858.GS155407@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 09:18:58AM +1100, David Chinner wrote:
> Only if the per-vfsmount writer counts got merged in 2.6.25-rcX. I'm not sure
> that they did. Christoph?

No, it didn't go in.  The new target is 2.6.26.

