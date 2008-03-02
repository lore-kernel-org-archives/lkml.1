Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbYCBTee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbYCBTee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYCBTeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:34:25 -0500
Received: from openfortress.nl ([213.189.19.244]:41932 "EHLO fame.vanrein.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753452AbYCBTeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:34:24 -0500
Date: Sun, 2 Mar 2008 19:34:16 +0000
From: Rick van Rein <rick@vanrein.org>
To: Rick van Rein <rick@vanrein.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Message-ID: <20080302193416.GA27780@phantom.vanrein.org>
References: <20080302134221.GA25196@phantom.vanrein.org> <20080302175326.GB32381@nineveh.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080302175326.GB32381@nineveh.local>
X-My-Coolest-Hack: http://rick.vanrein.org/linux/badram -> Exploit broken RAM
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> This is a great feature for those of us who value their money more
> than a few hours of time as well.  :-)

That's how it's most often used, indeed.  I do value the environmental
aspect as well: the potential for memory manufacturers (say, for the
$100 laptop) to ship out their broken memories at a low cost, thereby
delivering more products for a given amount of toxic waste created in
the chip etching process.

> I would very much like to see this patch in mainline

Many, many people want to.  I've been asked about it a lot, but always
lacked the time to figure out how.

> ISTR that one
> argument that has been historically made against this sort of thing is
> that it would make bug reports unreliable.

Actually it's broken memory that makes reports unreliable, not the patch :)

After the right set of broken addresses has been applied, the whole system
runs as reliably as any other system.  And I hope people have the wits to
mistrust a system for a while after they've plugged in broken DIMMs ;-)

> mechanism now, so that shouldn't be a showstopper -- if that's the
> only argument, then set a new taint flag, please.

I doubt that'll be necessary, but yes, it'd be a way out.  Thanks.

Cheers,
 -Rick
