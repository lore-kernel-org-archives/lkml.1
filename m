Return-Path: <linux-kernel-owner+w=401wt.eu-S1750788AbXBMQHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750788AbXBMQHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 11:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbXBMQHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 11:07:22 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55775 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbXBMQHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 11:07:20 -0500
Date: Tue, 13 Feb 2007 16:06:44 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Mark Lord <lkml@rtr.ca>
Cc: nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tilman Schmidt <tilman@imap.cc>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070213160644.GA22748@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mark Lord <lkml@rtr.ca>, nigel@nigel.suspend2.net,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Tilman Schmidt <tilman@imap.cc>,
	Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171147026.19894.16.camel@nigel.suspend2.net> <45CE5934.3020801@imap.cc> <200702110127.35631.rjw@sisk.pl> <1171233683.4493.81.camel@nigel.suspend2.net> <45D1DF66.6030906@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D1DF66.6030906@rtr.ca>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 10:55:18AM -0500, Mark Lord wrote:
> LKML is much more receptive to drivers that follow
> the "release early, release often" mantra.

Exactly.

> Which means we really have to be more accomodating of
> drivers that start out simple, and then gain all of the
> non-essential capabilities gradually over time.

We usually are, the endless flamewar lurkers might not :)
> 
> Simple observation here shows much more hostility :)
> to drivers that are simply "presented" as a complete whole.
> Often for good reason -- starting out with a framework
> and then adding the rest bit by bit allows for much better
> peer review and feedback.

*nod*

> And not all devices / situations need power management,
> and lack of documentation on the hardware often prevents
> us from implementing it at the outset.

*nod*

So can be use Mark's excellent post as closing of this
utterly useless thread and go on to real work now?

