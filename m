Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYCLNjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYCLNjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbYCLNjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:39:16 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:54390 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYCLNjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:39:15 -0400
Date: Wed, 12 Mar 2008 19:09:04 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH 03/17] sched: rt-group: full hierarchy support for
	the rt groups
Message-ID: <20080312133904.GB5264@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080309170850.256853000@chello.nl> <20080309170926.354453000@chello.nl> <20080312082532.GB3784@linux.vnet.ibm.com> <661de9470803120129l66497656o948c13c6c0c26766@mail.gmail.com> <1205314176.8514.219.camel@twins> <47D7DBE8.4090502@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D7DBE8.4090502@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 07:04:32PM +0530, Balbir Singh wrote:
> Peter Zijlstra wrote:
> > On Wed, 2008-03-12 at 13:59 +0530, Balbir Singh wrote:
> >> On Wed, Mar 12, 2008 at 1:55 PM, Dhaval Giani
> >> <dhaval@linux.vnet.ibm.com> wrote:
> >>         On Sun, Mar 09, 2008 at 06:08:53PM +0100, Peter Zijlstra
> >>         wrote:
> >>         > Update the -rt bits to support the full hierarchy support
> >>         started by Dhaval.
> >>         >
> >>         
> >>         
> >>         Thanks for the effort. Just a very minor comment. I will try
> >>         these out
> >>         and give more feedback.
> >>         
> >>         
> >>         > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >>         
> >>
> >> Shouldn't this have Dhaval's signed-off-by as well? Dhaval do you want
> >> to sign-off on these patches?
> > 
> > He can Ack it, but the 3rd patch was not authored by him.
> > 
> 
> So, the first two patches should have his sign-off then? I don't mean to
> nit-pick, but want to follow DCO correctly.
> 

They do, also have my From, just quilt mail ate it up. I hope peter can
find a workaround so that the next post of the patchset won't lose it
:).

-- 
regards,
Dhaval
