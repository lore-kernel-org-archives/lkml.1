Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYGEMCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYGEMCe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 08:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYGEMCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 08:02:24 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:3188 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbYGEMCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 08:02:23 -0400
Date: Sat, 5 Jul 2008 14:02:21 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Takashi Iwai <tiwai@suse.de>, David Woodhouse <dwmw2@infradead.org>,
       Hannes Reinecke <hare@suse.de>, Theodore Tso <tytso@mit.edu>,
       Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
Message-ID: <20080705120221.GC44773@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Andi Kleen <andi@firstfloor.org>, Takashi Iwai <tiwai@suse.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Hannes Reinecke <hare@suse.de>, Theodore Tso <tytso@mit.edu>,
	Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
	hugh@veritas.com, akpm@linux-foundation.org,
	kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org
References: <486E2260.5050503@garzik.org> <1215178035.10393.763.camel@pmac.infradead.org> <20080704141014.GA23215@mit.edu> <s5habgxloct.wl%tiwai@suse.de> <486E3622.1000900@suse.de> <1215182557.10393.808.camel@pmac.infradead.org> <20080704231322.GA4410@dspnet.fr.eu.org> <s5h4p746am3.wl%tiwai@suse.de> <20080705105317.GA44773@dspnet.fr.eu.org> <486F596C.8050109@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486F596C.8050109@firstfloor.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 01:22:20PM +0200, Andi Kleen wrote:
> Many distribution have some way for separate kernel module packages.
> It's essentially the same problem so it should be already solved
> in some way.

Errr, no.  Modules go in /lib/modules/`uname -r`, so no conflict.

  OG.
