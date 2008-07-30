Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYG3Qjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYG3Qjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 12:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbYG3QjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 12:39:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbYG3QjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 12:39:24 -0400
Date: Wed, 30 Jul 2008 09:31:52 -0700
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Frederik Deweerdt <deweerdt@free.fr>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       suresh.b.siddha@intel.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	00000002
Message-ID: <20080730163152.GA23036@suse.de>
References: <20080725095317.GA12636@skywalker> <20080728222643.GA6339@slug> <1217305335.5553.3.camel@marge.simson.net> <20080730090549.GA26904@elte.hu> <20080730022631.821d34a7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730022631.821d34a7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 02:26:31AM -0700, Andrew Morton wrote:
> On Wed, 30 Jul 2008 11:05:49 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > On Tue, 2008-07-29 at 00:26 +0200, Frederik Deweerdt wrote:
> > > > Hello  Aneesh,
> > > > 
> > > > On Fri, Jul 25, 2008 at 03:23:17PM +0530, Aneesh Kumar K.V wrote:
> > > > > [  163.378265] BUG: unable to handle kernel NULL pointer dereference at 00000002
> > > > > [  163.378276] IP: [<c0124933>] sched_power_savings_store+0x13/0x70
> > > > 
> > > > Does the attached patch solve the problem?
> > > 
> > > Patch seems to have missed the boat for rc1 too.
> 
> I grabbed Andi's 53rd copy and have sent it Linuswards.
> 
> > Greg?
> 
> We should make him maintain 2.6.27-rc1.1 ;)

I know I've been slow in getting back up to speed due to vacations and
work issues, but that's just cruel to suggest such a thing :)

thanks,

greg k-h
