Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZEBHCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZEBHCB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 03:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbZEBHBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 03:01:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53775 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbZEBHBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 03:01:51 -0400
Date: Sat, 2 May 2009 03:01:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: Chris Wedgwood <cw@f00f.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: linux-next: Tree for May 1 (devtmpfs)
Message-ID: <20090502070144.GA19849@infradead.org>
References: <20090501163405.973f9088.sfr@canb.auug.org.au> <49FB1521.5050500@oracle.com> <20090501165551.GA1889@puku.stupidest.org> <20090501225616.GA18064@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501225616.GA18064@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 03:56:16PM -0700, Greg KH wrote:
> As we discussed on irc, I think you no longer object to this, and see
> how it solves a real problem, and can probably help out your initramfs
> tools.

I defintively objet to the implementation, I'm in the process of writing
up the objections.  I must say I'm generally disappointed how fast
controversial stuff ends up in linux-next.  At least your tree
traditionally was quilt series so it can be dropped, unlike some other
people sucking stuff into gigantic git trees that never get rebased :P

