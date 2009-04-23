Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbZDWQcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbZDWQcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 12:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZDWQcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 12:32:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:46789 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZDWQcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 12:32:22 -0400
Date: Thu, 23 Apr 2009 16:25:43 +0000
From: Chris Wright <chrisw@sous-sol.org>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: Greg KH <greg@kroah.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, Eugene Teo <eteo@redhat.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Willy Tarreau <w@1wt.eu>, Michael Krufky <mkrufky@linuxtv.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Jake Edge <jake@lwn.net>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [stable] [patch 000/100] 2.6.29.2 -stable review
Message-ID: <20090423162543.GA15523@hera.kernel.org>
References: <20090423072020.428683652@sous-sol.org> <200904231608.42147.tvrtko.ursulin@sophos.com> <20090423154502.GA27609@kroah.com> <200904231717.25138.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904231717.25138.tvrtko.ursulin@sophos.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 16:25:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tvrtko Ursulin (tvrtko.ursulin@sophos.com) wrote:
> OK, will keep that in mind in the future. This is the first time I am trying 
> to get something into stable so I didn't know the right process. I assumed it 
> is enough to copy stable@kernel.org with anything resembling a regression fix 
> and you diligent people take care of it.

I like the optimism ;-)  Thanks for Cc'ing stable (I know I actually
checked for the resolution, and at the time it simply wasn't resolved yet).

thanks,
-chris
