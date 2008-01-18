Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbYAROjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbYAROjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbYAROjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:39:46 -0500
Received: from unthought.net ([212.97.129.88]:58315 "EHLO unthought.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbYAROjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:39:45 -0500
Date: Fri, 18 Jan 2008 15:39:43 +0100
From: Jakob Oestergaard <jakob@unthought.net>
To: "Giacomo A. Catenazzi" <cate@cateee.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Schwartz <davids@webmaster.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
Message-ID: <20080118143943.GQ25527@unthought.net>
Mail-Followup-To: Jakob Oestergaard <jakob@unthought.net>,
	"Giacomo A. Catenazzi" <cate@cateee.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Schwartz <davids@webmaster.com>,
	Johannes Weiner <hannes@saeurebad.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	clameter@sgi.com, penberg@cs.helsinki.fi
References: <MDEHLPKNGKAHNMBLJOLKIEGIJJAC.davids@webmaster.com> <alpine.LFD.1.00.0801171316390.14959@woody.linux-foundation.org> <20080118094826.GN25527@unthought.net> <479091B5.4060700@cateee.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479091B5.4060700@cateee.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 12:47:01PM +0100, Giacomo A. Catenazzi wrote:
...
> "restrict" exists for this reason. const is only about lvalue.

You think that I try to put more meaning into const than I do - but I don't.

Please read what I wrote, not what you want to think I wrote.

I agree that if I said what you seem to imply I said, then I would have been
wrong. But I didn't so I'm not ;)


-- 

 / jakob

