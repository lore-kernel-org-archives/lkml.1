Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbYHGRqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbYHGRqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYHGRqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:46:15 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14296 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbYHGRqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:46:14 -0400
Date: Thu, 7 Aug 2008 19:20:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "scameron@beardog.cca.cpqcorp.net" <scameron@beardog.cca.cpqcorp.net>
Subject: Re: [PATCH 6/6] cciss: fix bug if scsi tape support is disabled
Message-ID: <20080807172028.GX20055@kernel.dk>
References: <20080730211842.GF1758@roadking.ldev.net> <20080804095633.GA20055@kernel.dk> <20080805153012.0076396e.akpm@linux-foundation.org> <20080806130825.1567d882.sfr@canb.auug.org.au> <20080806103308.GM20055@kernel.dk> <20080807094305.8d315d06.sfr@canb.auug.org.au> <0F5B06BAB751E047AB5C87D1F77A778826B3F16682@GVW0547EXC.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A778826B3F16682@GVW0547EXC.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07 2008, Miller, Mike (OS Dev) wrote:
> 
> 
> > -----Original Message-----
> > From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> > Sent: Wednesday, August 06, 2008 6:43 PM
> > To: Jens Axboe
> > Cc: Andrew Morton; Miller, Mike (OS Dev);
> > linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
> > Subject: Re: [PATCH 6/6] cciss: fix bug if scsi tape support
> > is disabled
> >
> > Hi Jens,
> >
> > On Wed, 6 Aug 2008 12:33:08 +0200 Jens Axboe
> > <jens.axboe@oracle.com> wrote:
> > >
> > > Thanks, but just keep pulling linux-next and I'll try and get them
> > > uptodate more frequently :-)
> >
> 
> I still can't find my latest patches in any tree. Jens?

It's in for-next, for-akpm, and for-linus. It'll be going upstream for
this release, 2.6.27.

-- 
Jens Axboe

