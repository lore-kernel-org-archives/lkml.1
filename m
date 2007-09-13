Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbXIMOk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbXIMOk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbXIMOkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:40:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36483 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947AbXIMOkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:40:18 -0400
Date: Thu, 13 Sep 2007 07:42:36 -0700
From: Greg KH <gregkh@suse.de>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: David Miller <davem@davemloft.net>, kovedi@gmail.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Sparc64 BUG] hangup under booting 2.6.22.X whith Sparc64
Message-ID: <20070913144236.GE3309@suse.de>
References: <406fe6c90709102233m2472e6c4h7d329a3f64692645@mail.gmail.com> <20070911.083823.15264559.davem@davemloft.net> <406fe6c90709120047g1cf0a995r391e9fe1fbac7101@mail.gmail.com> <20070912.011103.41643890.davem@davemloft.net> <6101e8c40709130559l69b87211k763c70a90d3d8221@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40709130559l69b87211k763c70a90d3d8221@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 02:59:09PM +0200, Oliver Pinter wrote:
> Hi David!
> 
> On 9/12/07, David Miller <davem@davemloft.net> wrote:
> > From: "K?vedi_Kriszti?n" <kovedi@gmail.com>
> > Date: Wed, 12 Sep 2007 09:47:45 +0200
> >
> > > The patch work fine the kernel booting up without error messages.
> >
> > Thanks for testing.
> 
> this patch releated for 2.6.22.y too.
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=2cc7345ff71b27b5ac99e49ad7de39360042f601
> we (Krisz and me) tested with 2.6.22.6, the server works and no errors
> become for now.

Are you asking for this patch to go into the 2.6.22-y tree?  If so,
please send it to the stable@kernel.org address so we know to add it to
the queue.

thanks,

greg k-h
