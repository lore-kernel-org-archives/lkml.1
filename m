Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbYA2W4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbYA2W4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYA2W4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:56:33 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:49076 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbYA2W4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:56:31 -0500
Date: Wed, 30 Jan 2008 00:57:01 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>, rms@gnu.org
Subject: Re: ndiswrapper and GPL-only symbols redux
Message-ID: <20080129225701.GS8767@does.not.exist>
References: <1201641765.18773.35.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1201641765.18773.35.camel@dv>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 04:22:45PM -0500, Pavel Roskin wrote:
> Hello!
> 
> It have come to my attention that a patch has been committed to the
> kernel with the explicit purpose of tainting ndiswrapper - the kernel
> module allowing Windows NDIS drivers for Ethernet and Wireless cards to
> be used by the kernel.
>...
> Just to reiterate some points from the old discussion:
>...
> - no copyright violation is involved, as Windows drivers are not derived
> from Linux sources
>...

It is interesting that someone posting with an @gnu.org address claims
that dynamic linking of not GPLv2 compatible code into GPLv2 code was
not a copyright violation.

Is it an official statement of the FSF that such linking is considered 
legal?

(RMS added to Cc)

> Regards,
> Pavel Roskin

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

