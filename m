Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbYIVHOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbYIVHOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 03:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbYIVHOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 03:14:25 -0400
Received: from mail.atheros.com ([12.36.123.2]:39705 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYIVHOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 03:14:24 -0400
Date: Mon, 22 Sep 2008 00:14:21 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@atheros.com>
CC: Steven Noonan <steven@uplinklabs.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       Johannes Berg <johannes@sipsolutions.net>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27
	(rc5, rc6, probably others)
Message-ID: <20080922071421.GA19850@tesla>
References: <f488382f0809192029w601e0e72x5c3affc3dbe65118@mail.gmail.com> <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com> <43e72e890809201357y1413a151r85aad7cc16440cf4@mail.gmail.com> <1221944338.3023.8.camel@johannes.berg> <43e72e890809201403w2c4511fdv2fe26bbcf49ccdd7@mail.gmail.com> <f488382f0809201422rdabeff4g435bf3d4a7e9fa3@mail.gmail.com> <43e72e890809201426x61c94bfej2dcda1c178be81b@mail.gmail.com> <f488382f0809201448l21434f11n12311e308f9952d7@mail.gmail.com> <f488382f0809201848w1e59cc19i8235c7c74c44fc10@mail.gmail.com> <20080922065453.GD19580@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080922065453.GD19580@tesla>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 11:54:53PM -0700, Luis Rodriguez wrote:
> On Sat, Sep 20, 2008 at 06:48:05PM -0700, Steven Noonan wrote:
> >
> > OK, here's the time index at which it b0rked:
> >
> > 18:28:42          sum   1155.00
> > 18:28:43          sum   1339.00
> > 18:28:44          sum  18355.00
> > 18:28:45          sum  17845.45
> >
> > And the entire log of the minute 18:28 is here:
> > http://www.uplinklabs.net/~tycho/linux/18.28.00-59.log.gz
> >
> > It looks pretty crazy.
> 
> Thanks, I'll take a look when I get a chance (remember aggretion
> is in the queue too) unless someone beats me to it. Asking in advance
> -- if you can also provide a log of minutes 43, 44 and 45 that would
> be great, but this may just be enough.

Oh wait, those are seconds, nevermind :)

  Luis
