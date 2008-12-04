Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbYLDMu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbYLDMu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbYLDMuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:50:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbYLDMuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:50:14 -0500
Date: Thu, 4 Dec 2008 07:50:06 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>,
       Lachlan McIlroy <lachlan@sgi.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: XFS breakage on m68k (was: Re: linux-next: Tree for December 3)
Message-ID: <20081204125006.GA13411@infradead.org>
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au> <Pine.LNX.4.64.0812040956370.10635@anakin> <20081204121330.GA18815@infradead.org> <20081204234603.b5a28cd6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204234603.b5a28cd6.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 11:46:03PM +1100, Stephen Rothwell wrote:
> fs/xfs/linux-2.6/xfs_file.c:365: error: 'xfs_file_compat_invis_ioctl' undeclared here (not in a function)
> 
> Eric mentioned that your patch "had a problem of its own", so I assumed
> that was it and left it removed from today's linux-next.

Yeah, but Niv fixed it up and the correct version is not in the xfs git
tree.

