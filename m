Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbZGMRRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbZGMRRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbZGMRRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:17:35 -0400
Received: from gw1.transmode.se ([213.115.205.20]:38133 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756632AbZGMRRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:17:34 -0400
In-Reply-To: <OFF188389D.68E638A2-ONC12575F2.00568C5B-C12575F2.0057FC95@LocalDomain>
References: <20090713151911.GA28114@oksana.dev.rtsoft.ru> <OFF188389D.68E638A2-ONC12575F2.00568C5B-C12575F2.0057FC95@LocalDomain>
Subject: Re: [PATCH 0/2] Setting GPIOs simultaneously
X-KeepSent: 8C0227E0:BF13DCDF-C12575F2:005EA83F;
 type=4; name=$KeepSent
To: avorontsov@ru.mvista.com
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OF8C0227E0.BF13DCDF-ONC12575F2.005EA83F-C12575F2.005EFD2C@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Mon, 13 Jul 2009 19:17:31 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5 HF407|May 07, 2009) at
 2009-07-13 19:17:32
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joakim Tjernlund/Transmode wrote on 13/07/2009 18:01:02:
>
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote on 13/07/2009 17:19:11:
> >
> > Hi all,
> >
> > I've been sitting on these patches for some time, but now it appears
> > that the set_sync() feature is needed elsewhere. So here are the
> > patches.
> >
> > Joakim, I think this is what you need.

> Yes, it sure looks so :) I will have to look closer later as
> I will be traveling the next few days.

hmm, one must define a new OF syntax (and update the spi_mpc83xx driver) to
use this(I think). Have you given this any thought?

 Jocke

