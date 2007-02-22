Return-Path: <linux-kernel-owner+w=401wt.eu-S1422840AbXBVDrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422840AbXBVDrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 22:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422849AbXBVDrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 22:47:53 -0500
Received: from mx1.suse.de ([195.135.220.2]:41695 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422840AbXBVDrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 22:47:53 -0500
From: Neil Brown <neilb@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Date: Thu, 22 Feb 2007 14:46:55 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17885.4655.13602.796653@notabene.brown>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>,
       schwidefsky@de.ibm.com
Subject: Re: Block layer still stack abuser?
In-Reply-To: message from Christoph Hellwig on Thursday February 22
References: <45D59C3C.4090403@drzeus.cx>
	<17885.1120.437885.35438@notabene.brown>
	<20070222034424.GC9027@infradead.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday February 22, hch@infradead.org wrote:
> On Thu, Feb 22, 2007 at 01:48:00PM +1100, Neil Brown wrote:
> > Might this:
> >    http://lkml.org/lkml/2007/2/10/22
> > 
> > relate to your question?
> > If you are talking about stacking block device (via dm or md), then a
> > patch to fix this in in -mm but there are or were some potential
> > issues in dm that seem to be holding it up.
> 
> What are the current blocking issues?  There are a lot of users of dm/md
> double-stacking (e.g. mirroring + multipath) that are in deep trouble
> currently and could be helped greatly with this patch.

All I know is what is in that mail message that I linked to.

NeilBrown
