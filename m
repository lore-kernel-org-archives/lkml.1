Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYGEELJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYGEELJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 00:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbYGEEKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 00:10:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46912 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbYGEEKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 00:10:53 -0400
Message-ID: <486EF420.40801@garzik.org>
Date: Sat, 05 Jul 2008 00:10:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Olivier Galibert <galibert@pobox.com>,
       David Woodhouse <dwmw2@infradead.org>, Hannes Reinecke <hare@suse.de>,
       Takashi Iwai <tiwai@suse.de>, Theodore Tso <tytso@mit.edu>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
References: <486D6DDB.4010205@infradead.org> <87ej6armez.fsf@basil.nowhere.org> <1215177044.10393.743.camel@pmac.infradead.org> <486E2260.5050503@garzik.org> <1215178035.10393.763.camel@pmac.infradead.org> <20080704141014.GA23215@mit.edu> <s5habgxloct.wl%tiwai@suse.de> <486E3622.1000900@suse.de> <1215182557.10393.808.camel@pmac.infradead.org> <20080704231322.GA4410@dspnet.fr.eu.org> <20080704235839.GA5649@khazad-dum.debian.net>
In-Reply-To: <20080704235839.GA5649@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> Nothing too dificult to pull off, but something that needs to be done before
> this entire thing gets deployed on unsuspecting users.  It is bad enough
> that it created such a commotion when deployed on unsuspecting developers...


If I may...  that summarizes my entire position in this thread.

The current mess is light years from being deployable to average users.

	Jeff


