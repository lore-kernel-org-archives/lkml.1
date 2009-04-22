Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZDVOs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZDVOs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 10:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbZDVOsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 10:48:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51907 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754617AbZDVOso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 10:48:44 -0400
Date: Wed, 22 Apr 2009 15:49:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Kosin <jkosin@beta.intcomgrp.com>
Cc: Mark Brown <broonie@sirena.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [RFD] voltage/current regulator consumer interface
Message-ID: <20090422154920.0dda2380@lxorguk.ukuu.org.uk>
In-Reply-To: <49EF2A3C.2050107@support.intcomgrp.com>
References: <ct38K-3Fq-11@gated-at.bofh.it>
	<ct38K-3Fq-9@gated-at.bofh.it>
	<ctmXD-1yA-3@gated-at.bofh.it>
	<ctnK4-2zP-11@gated-at.bofh.it>
	<ctoG9-458-7@gated-at.bofh.it>
	<ctoG9-458-5@gated-at.bofh.it>
	<ctoPK-4y5-5@gated-at.bofh.it>
	<ctoZv-4KN-23@gated-at.bofh.it>
	<ctFxn-5OC-11@gated-at.bofh.it>
	<ctG0r-6HL-31@gated-at.bofh.it>
	<49EF2A3C.2050107@support.intcomgrp.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > In power management line normally refers to the core, unregulated power
> > bus for the system and a line supply would normally be something like a
> > wall wart that supplies this directly when it's connected.
> 
> Can I suggest:
> "supply-switch" or "regulator-switch" may make more sense for the moment.

Can I suggest they don't. The naming should reflect the naming actually
used in the field by people working on the technology otherwise arbitary
renaming just creates confusion

The supply switch is the big switch on the back

Alan
