Return-Path: <linux-kernel-owner+w=401wt.eu-S1761208AbXKMVPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761208AbXKMVPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758719AbXKMVPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:15:14 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33528 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758383AbXKMVPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:15:11 -0500
Date: Tue, 13 Nov 2007 21:12:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Mark Lord <liml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113211256.1d18fe1a@the-village.bc.nu>
In-Reply-To: <20071113200028.GJ4250@stusta.de>
References: <20071113134029.GA30978@elte.hu>
	<4739AFE0.20705@rtr.ca>
	<20071113164650.GA28493@elte.hu>
	<4739E3D0.10201@rtr.ca>
	<20071113181228.GF4250@stusta.de>
	<4739EA83.5040006@rtr.ca>
	<20071113183605.GG4250@stusta.de>
	<4739F12E.5020807@rtr.ca>
	<20071113190428.GH4250@stusta.de>
	<4739FA4D.1050900@rtr.ca>
	<20071113200028.GJ4250@stusta.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Bug fixing is not about finding someone to blame, it's about getting the 
> bug fixed.

Partly - its also about understanding why the bug occurred and making it
not happen again.
