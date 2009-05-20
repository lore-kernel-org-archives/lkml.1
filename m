Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbZETLcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbZETLcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbZETLV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:21:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52151 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbZETLVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:21:21 -0400
Date: Wed, 20 May 2009 13:27:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [BUG 2.6.30-rc1] panic when loading oprofile
Message-ID: <20090520112720.GB8684@one.firstfloor.org>
References: <alpine.WNT.2.00.0905131327430.7052__41366.1100705669$1242253861$gmane$org@jbrandeb-desk1.amr.corp.intel.com> <87fxf6pmh5.fsf@basil.nowhere.org> <20090516162017.2525511c.akpm@linux-foundation.org> <F169D4F5E1F1974DBFAFABF47F60C10A335277B5@orsmsx507.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F169D4F5E1F1974DBFAFABF47F60C10A335277B5@orsmsx507.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 12:13:24AM -0700, Brandeburg, Jesse wrote:
> Andrew Morton wrote:
> > On Fri, 15 May 2009 14:41:26 +0200 Andi Kleen <andi@firstfloor.org>
> > wrote:
> >
> > > "Brandeburg, Jesse" <jesse.brandeburg@intel.com> writes:
> > >
> > > Hi Jesse,
> > >
> > > > when starting a profile run on the latest net-next kernel, I'm
> > currently
> > > > trying to reproduce on 2.6.30-rc5 stock.
> > >
> > > Were you able to reproduce it?
> 
> For some reason I can no longer reproduce, I'll add a note to the bug too.

Did you have the nmi watchdog enabled?  Does it tick now?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
