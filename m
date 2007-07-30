Return-Path: <linux-kernel-owner+w=401wt.eu-S967126AbXG3SaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967126AbXG3SaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934097AbXG3SaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:30:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42780 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760522AbXG3SaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:30:02 -0400
Date: Mon, 30 Jul 2007 19:29:59 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Hawkins <darthmdh@gmail.com>
Cc: Jacob Braun <jwbraun@gmail.com>, kriko <kristjan.ugrin@gmail.com>,
       ck@vds.kolivas.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Message-ID: <20070730182959.GA29151@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Matthew Hawkins <darthmdh@gmail.com>,
	Jacob Braun <jwbraun@gmail.com>, kriko <kristjan.ugrin@gmail.com>,
	ck@vds.kolivas.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-mm@kvack.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu> <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com> <20070729204716.GB1578@elte.hu> <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com> <20070730114649.GB19186@elte.hu> <op.tv90xghwatcbto@linux.site> <d3380cee0707300831m33d896aufcbdb188576940a2@mail.gmail.com> <b21f8390707300925i76cb08f2j55bba537cf853f88@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b21f8390707300925i76cb08f2j55bba537cf853f88@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 02:25:47AM +1000, Matthew Hawkins wrote:
> 
> The ATI drivers (current 8.39.4) were broken by
> commit e21ea246bce5bb93dd822de420172ec280aed492
> Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Bad call on the "nobody was using these", Martin :(

Sorry to use foul language once again after a while, but:

	Fuck you Martin!

not only is complaining about illegal binary crap totally offtopic
on this list, and making youself a fool for using that piece of shit
is annoying enough, but don't even try to badmouth Martin for doing
important and needed cleanups.  And now get out of here!
