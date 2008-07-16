Return-Path: <linux-kernel-owner+w=401wt.eu-S1759178AbYGPQaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178AbYGPQaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbYGPQaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:30:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbYGPQaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:30:00 -0400
Subject: Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>, Guy Cohen <guy@cguy.net>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1216196668.3422.2.camel@johannes.berg>
References: <20080709190915.GA8238@tuxdriver.com>
	 <247d6d340807140805gfb6523en74384f6f47469d79@mail.gmail.com>
	 <20080715174246.GA3117@tuxdriver.com>
	 <1216145731.13411.25.camel@localhost.localdomain>
	 (sfid-20080715_201731_895315_46FC8F2F)  <1216196668.3422.2.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 16 Jul 2008 12:27:59 -0400
Message-Id: <1216225679.21973.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-16 at 10:24 +0200, Johannes Berg wrote:
> > > Not sure exactly what you mean with this one.  Are you talking about
> > > the lib80211 line item?  Or enhancements to the mac80211 component
> > > to support full(er) MAC designs?
> > 
> > I hope just lib80211.  We shouldn't be extending mac80211 to fullmac or
> > quasi-fullmac parts.  But we can certainly share a lot of stuff.
> > lib80211 is where I see any additional fullmac effort going.
> 
> Just a minor point wrt. lib80211: I see little use in creating yet
> another module since hopefully soon enough fullmac chipsets will bind
> cfg80211 anyway so all of that stuff might as well be in there.

worksforme, I don't really care where that stuff goes as long as we get
it in one place :)

Dan

