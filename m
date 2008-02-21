Return-Path: <linux-kernel-owner+w=401wt.eu-S932115AbYBUMjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbYBUMjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 07:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYBUMjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 07:39:47 -0500
Received: from mail2.neteffect.com ([204.57.75.68]:8766 "EHLO
	mail2.neteffect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbYBUMjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 07:39:46 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [ofa-general] [2.6 patch] infiniband/hw/nes/nes_verbs.c: fix off-by-one
Date: Thu, 21 Feb 2008 06:39:45 -0600
Message-ID: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
In-Reply-To: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ofa-general] [2.6 patch] infiniband/hw/nes/nes_verbs.c: fix off-by-one
Thread-Index: Ach0F2EYM4bTqehKSfOyes7uKJ+ApwAALd9wABt2PjA=
From: "Glenn Streiff" <gstreiff@NetEffect.com>
To: "Roland Dreier" <rdreier@cisco.com>, "Adrian Bunk" <bunk@kernel.org>
Cc: "Faisal Latif" <flatif@NetEffect.com>, <linux-kernel@vger.kernel.org>,
       <general@lists.openfabrics.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >  > No, 51af33e8 was for a similar same bug 400 lines below 
> this bug...
> > 
> > Heh, sorry.
> > 
> > Glenn -- please review Adrian's patches and let me know 
> which ones are
> > good to apply.
> > 
> 

I went ahead and created a patch series and attributed Adrian
for the patches of his I liked.  There were a couple that
I tweaked.  Wasn't sure if all the hunks would apply nicely
after that if we mixed and matched his and mine, hence the series.

Hope that's okay.  Should I have gotten his ack for the ones
I rewrote?  The fixes were pretty small so I figured they didn't
really need more review.

The patch series is on the way...

Glenn
