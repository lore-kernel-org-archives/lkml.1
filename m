Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbXHMXKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbXHMXKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbXHMXJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:09:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543AbXHMXJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:09:48 -0400
Date: Mon, 13 Aug 2007 19:09:42 -0400
From: Dave Jones <davej@redhat.com>
To: Zan Lynx <zlynx@acm.org>
Cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Subject: Re: How to make -mm a more viable testbed (was: [PATCH] [1/12]
	x86: Work around mmio config space quirk on AMD)
Message-ID: <20070813230942.GA5804@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Zan Lynx <zlynx@acm.org>,
	Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
References: <200708130808.46989.a1426z@gawab.com> <1187037607.7855.21.camel@localhost> <20070813210956.GA18334@redhat.com> <1187046443.7855.38.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187046443.7855.38.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 05:07:23PM -0600, Zan Lynx wrote:
 > On Mon, 2007-08-13 at 17:09 -0400, Dave Jones wrote:
 > > On Mon, Aug 13, 2007 at 02:40:06PM -0600, Zan Lynx wrote:
 > >  > I thought most people running -mm were running klive, which shou
 > >  > ld tell kernel versions, uptime and other things.  I run it, anyway.
 > >  > 
 > >  > http://klive.cpushare.com/
 > > 
 > > If that's the case, there are 3 people running 2.6.23-rc2-mm2.
 > > I suspect the actual number of users is considerably higher.
 > > Somehow I doubt that 'most' people are running klive.
 > 
 > I had thought Andrew asked people to do it at one point.  Could have
 > been someone else, I suppose.  Ah, it was Andrea Arcangeli.
 > 
 > At the time, it seemed more people were doing it.  I guess not though.
 > Or there really aren't many people running the latest -mm.  It *is*
 > quite a hassle.  I only do it because I'm crazy. :)
 > 
 > I think klive is a good idea for tracking kernel testing.  Perhaps
 > mentioning it here again will get more people running it.
 > 
 > I suppose that someone could try to estimate usage by counting patch
 > downloads off kernel.org.

The fallout from bugs found each time Andrew makes an announcement
should be a fairly good indicator :-)

	Dave

-- 
http://www.codemonkey.org.uk
