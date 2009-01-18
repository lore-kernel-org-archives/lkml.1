Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbZARWHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbZARWHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 17:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbZARWHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 17:07:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33462 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbZARWHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 17:07:39 -0500
Date: Sun, 18 Jan 2009 17:06:57 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, chris.mason@oracle.com,
       handygewinnspiel@gmx.de, matthew@wil.cx, rjw@sisk.pl, HWerner4@gmx.de,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mchehab@infradead.org, stable@kernel.org,
       Christoph Hellwig <hch@lst.de>, Lachlan McIlroy <lachlan@sgi.com>,
       xfs mailing list <xfs@oss.sgi.com>
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
Message-ID: <20090118220657.GA14814@infradead.org>
References: <20090113105947.9e774b69.akpm@linux-foundation.org> <20090113191757.74290@gmx.net> <20090113113700.776a94b5.akpm@linux-foundation.org> <20090113203843.GJ29283@parisc-linux.org> <1231957750.8269.28.camel@think.oraclecorp.com> <496E56EB.2030301@gmx.de> <1231968240.8269.48.camel@think.oraclecorp.com> <496E5AB2.7040507@sandeen.net> <20090114134417.e6b29b52.akpm@linux-foundation.org> <496E5DB8.1030007@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496E5DB8.1030007@sandeen.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 03:48:40PM -0600, Eric Sandeen wrote:
> > This patch applies OK to 2.6.27 and 2.6.28.  Is it also needed there? 
> > If so, it should have had "Cc: <stable@kernel.org>" in the changelog so
> > that it doesn't get lost.
> > 
> 
> It is needed for .28, but should not be needed for .27 AFAIK.

That's correct.
