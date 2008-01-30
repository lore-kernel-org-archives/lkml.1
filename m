Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbYA3Ae6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbYA3Ae6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYA3Aes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:34:48 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52541 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbYA3Aer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:34:47 -0500
Date: Wed, 30 Jan 2008 02:35:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: =?utf-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ndiswrapper and GPL-only symbols redux
Message-ID: <20080130003519.GB1802@does.not.exist>
References: <1201641765.18773.35.camel@dv> <20080129225701.GS8767@does.not.exist> <yw1x8x2843kt.fsf@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yw1x8x2843kt.fsf@mansr.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 11:25:22PM +0000, Måns Rullgård wrote:
> Adrian Bunk <bunk@kernel.org> writes:
> 
> > On Tue, Jan 29, 2008 at 04:22:45PM -0500, Pavel Roskin wrote:
> >> Hello!
> >> 
> >> It have come to my attention that a patch has been committed to the
> >> kernel with the explicit purpose of tainting ndiswrapper - the kernel
> >> module allowing Windows NDIS drivers for Ethernet and Wireless cards to
> >> be used by the kernel.
> >>...
> >> Just to reiterate some points from the old discussion:
> >>...
> >> - no copyright violation is involved, as Windows drivers are not derived
> >> from Linux sources
> >>...
> >
> > It is interesting that someone posting with an @gnu.org address claims
> > that dynamic linking of not GPLv2 compatible code into GPLv2 code was
> > not a copyright violation.
> 
> As long as you don't distribute /proc/kcore, I can't see how the GPL
> would have any say in the matter.  The Windows drivers are (unrelated
> violations aside) clearly not derived from GPL code.

Someone might sell a laptop with Linux installed?

> IANAL
> 
> Måns Rullgård

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

