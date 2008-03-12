Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYCLX0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYCLX0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYCLX0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:26:06 -0400
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:40037
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565AbYCLX0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:26:06 -0400
X-Trace: 61365328/mk-outboundfilter-1.mail.uk.tiscali.com/F2S/$ACCEPTED/freedom2Surf-customers/195.137.94.162
X-SBRS: None
X-RemoteIP: 195.137.94.162
X-IP-MAIL-FROM: spyro@f2s.com
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkcBAO8C2EfDiV6i/2dsb2JhbAAIpn4
X-IP-Direction: IN
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
From: ian <spyro@f2s.com>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200803121452.47600.david-b@pacbell.net>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main>
	 <200803120031.59742.david-b@pacbell.net>
	 <20080312130216.GA26583@rakim.wolfsonmicro.main>
	 <200803121452.47600.david-b@pacbell.net>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 23:26:01 +0000
Message-Id: <1205364361.24230.4.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-12 at 13:52 -0800, David Brownell wrote:
> > I don't see a particular problem fitting this into the structure of
> > the current API - to me the switches inflexible regulators with no
> > configurable voltage control of their own.
> 
> To me, they aren't regulators at all.  :)

I dunno.

Regulate - to control.

A switch certainly controls voltage. Admittedly the granularity is a
little coarser than a nice digitally controlled regulator, but it fits
the model...

