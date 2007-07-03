Return-Path: <linux-kernel-owner+w=401wt.eu-S1760561AbXGCXJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561AbXGCXJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 19:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbXGCXJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 19:09:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48083 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755514AbXGCXJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 19:09:38 -0400
Date: Wed, 4 Jul 2007 09:09:02 +1000
From: David Chinner <dgc@sgi.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-ide@vger.kernel.org,
       David Chinner <dgc@sgi.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [1/2] 2.6.22-rc7: known regressions
Message-ID: <20070703230902.GH31489@sgi.com>
References: <468A7D14.1050505@googlemail.com> <200707031950.27162.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707031950.27162.bzolnier@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 07:50:26PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Tuesday 03 July 2007, Michal Piotrowski wrote:
> 
> > IDE
> > 
> > Subject    : 2.6.22-rcX: hda: lost interrupt
> > References : http://lkml.org/lkml/2007/6/29/121
> > Submitter  : David Chinner <dgc@sgi.com>
> > Status     : unknown
> 
> David, any news on this one?
> 
> Have you tried libata as suggested by Jeff?

Not yet - I've been flat out and haven't got back to it yet.
I'll try to get to it today.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
