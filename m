Return-Path: <linux-kernel-owner+w=401wt.eu-S1762538AbYGOSRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762538AbYGOSRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757872AbYGOSR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:17:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755AbYGOSR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:17:27 -0400
Subject: Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Guy Cohen <guy@cguy.net>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080715174246.GA3117@tuxdriver.com>
References: <20080709190915.GA8238@tuxdriver.com>
	 <247d6d340807140805gfb6523en74384f6f47469d79@mail.gmail.com>
	 <20080715174246.GA3117@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 14:15:31 -0400
Message-Id: <1216145731.13411.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 13:42 -0400, John W. Linville wrote:
> On Mon, Jul 14, 2008 at 06:05:13PM +0300, Guy Cohen wrote:
> > I think that probably the most burning topics were a little diminished
> > in our agenda, and should be put higher:
> > - cfg80211/nl80211 - much of the current wext begins to fall behind
> > the emerging capabilities of the mac80211 and moreover - from future
> > abilities and needs of future fullmac devices. The functionality and
> > ABI to userspace must be finalized as soon as possible. The status of
> > this is very unclear and should be treated more thoroughly, and it
> > seems it can't be shared with 5 other topics in less than 2 hours.
> 
> FWIW, I listed this one first under Future Work.
> 
> > - fullmac support - seems to be very relevant in the next couple of
> > years with the integration of wifi into low power devices running
> > linux.
> 
> Not sure exactly what you mean with this one.  Are you talking about
> the lib80211 line item?  Or enhancements to the mac80211 component
> to support full(er) MAC designs?

I hope just lib80211.  We shouldn't be extending mac80211 to fullmac or
quasi-fullmac parts.  But we can certainly share a lot of stuff.
lib80211 is where I see any additional fullmac effort going.

Dan

> > I think that these two topics should take precedence over other topics
> > that although important consume more time in the agenda, and are
> > currently less likely to have impact on the average users such as 11s
> > and 11w.
> > 
> > it would be good if these topics will get substantial time slot in the agenda.
> 
> There are lots of items listed, and I'm not sure we will cover all
> of them.  If there are any that you would like to suggest be dropped
> completely then please do so.
> 
> That said, I don't think we have enough time for real working sessions
> on Tuesday.  I think it would be better just to touch on a variety
> of topics that can benefit from some face-to-face discussions.
> From that perspective, I think some status reports and some brief
> proposals are most appropriate.
> 
> I'll post a revised (mostly just augmented) agenda proposal today.
> 
> John

