Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbZC1AIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbZC1AIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758789AbZC1AIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:08:32 -0400
Received: from ara.aytolacoruna.es ([91.117.124.165]:35642 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbZC1AIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:08:31 -0400
Date: Sat, 28 Mar 2009 01:08:24 +0100
From: Santiago Garcia Mantinan <manty@manty.net>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: uli526x hangs on 2.6.29, not on rc8
Message-ID: <20090328000824.GA5997@dis.manty.net>
References: <20090326231515.GA6612@dis.manty.net> <200903270102.00104.elendil@planet.nl> <20090327180458.GA4459@dis.manty.net> <200903272113.45324.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903272113.45324.elendil@planet.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Known issue probably. Try: http://lkml.org/lkml/2009/3/25/217
> > Yes, seems related, I'm testing that patch right now on my machine, but
> > I'm wondering if I should test that one or this one
> > (http://www.spinics.net/lists/netdev/msg92829.html) sent also by
> > Herbert to the netdev list but at a later time.  I'll try test the
> > second one also just in case.
> No, the plain revert is safer.

Ok, I have tested both during quite a long time (hours compared to the few
minutes it took the system to hang before) and both patches seem to work ok,
I'll stick with the first one following your recommendations.

Thanks!
-- 
Manty/BestiaTester -> http://manty.net
