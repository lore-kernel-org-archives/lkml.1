Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbXFCXZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbXFCXZR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 19:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbXFCXZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 19:25:06 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:2218 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbXFCXZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 19:25:04 -0400
X-Greylist: delayed 1403 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jun 2007 19:25:04 EDT
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Daniel Hazelton <dhazelton@enter.net>,
       Anand Jahagirdar <anandjigar@gmail.com>, security@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Patch related with Fork Bombing Atack
References: <25ae38200705310645n5e913a91weaa14521908f7989@mail.gmail.com>
	<20070531134611.GZ32105@kernel.dk>
	<25ae38200705312348r3cd02c90h5080617fa1f0a987@mail.gmail.com>
	<200706010325.23185.dhazelton@enter.net>
	<20070601073020.GL32105@kernel.dk>
From: Nix <nix@esperi.org.uk>
Emacs: the road to Hell is paved with extensibility.
Date: Mon, 04 Jun 2007 00:01:21 +0100
In-Reply-To: <20070601073020.GL32105@kernel.dk> (Jens Axboe's message of "1 Jun 2007 08:31:59 +0100")
Message-ID: <87odjw8wxq.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-sgs_public_dcc_server-Metrics: hades 1199; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 Jun 2007, Jens Axboe told this:
> I think Anand is assuming that because syslog may coalesce identical
> messages into "repeated foo times" in the messages file, that it's not a
> dos. That is of course wrong.

Not all syslog daemons do that, anyway. (syslog-ng doesn't, for one.)

-- 
`On a scale of one to ten of usefulness, BBC BASIC was several points ahead
 of the competition, scoring a relatively respectable zero.' --- Peter Corlett
