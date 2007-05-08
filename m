Return-Path: <linux-kernel-owner+w=401wt.eu-S970359AbXEHXlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970359AbXEHXlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968060AbXEHXlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:41:12 -0400
Received: from kanga.kvack.org ([66.96.29.28]:49693 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967979AbXEHXlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:41:11 -0400
Date: Tue, 8 May 2007 20:41:18 -0300
From: Marcelo Tosatti <marcelo@kvack.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Dan Williams <dcbw@redhat.com>, David Miller <davem@davemloft.net>,
       penberg@cs.helsinki.fi, linville@tuxdriver.com, hch@infradead.org,
       linux-wireless@vger.kernel.org, marcelo@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: Please pull 'revert-libertas' branch of wireless-2.6
Message-ID: <20070508234118.GA3472@dmt>
References: <20070507141143.GB5125@tuxdriver.com> <463F443A.5000306@garzik.org> <84144f020705080247v74ebcd26y27c2f1e61529b215@mail.gmail.com> <20070508.132737.104034594.davem@davemloft.net> <4640E3BF.8080401@garzik.org> <1178659763.14888.2.camel@localhost.localdomain> <4640FC76.4090908@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4640FC76.4090908@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 06:40:54PM -0400, Jeff Garzik wrote:
> Dan Williams wrote:
> >I'll audit the list of ioctls and remove ones that may be objectionable,
> >and we'll go back through them after 2.6.22 and add back in ones that
> >are actually required.  Keep the API/ABI small and expand if necessary.
> >What's the timeframe required here?  Linville said a few days at the
> >most.
> 
> Ideally, before 2.6.22-rc1.  No set date, but generally it's a week or 
> two after merge window opens.
> 
> But even if you miss -rc1, we MUST get in the ioctl removal before 
> 2.6.22 release.  This is certainly exception to the "nothing but bug 
> fixes" rule -- or perhaps it is following the rule, if you consider the 
> ioctls' existence a bug :)
> 
> Getting the CodingStyle fixes in before 2.6.22-rc1 would be nice, but, 
> as I noted, lower priority than serious stuff like ioctl consideration.

There is also a bunch of updates pending. I'm sending them over this
week.

Dan: I'll be sending everything thats currently in our tree but not
mainline.
