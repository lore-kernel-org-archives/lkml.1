Return-Path: <linux-kernel-owner+w=401wt.eu-S1030927AbXFHReT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030927AbXFHReT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932629AbXFHReK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:34:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35739 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768AbXFHReJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:34:09 -0400
Date: Fri, 8 Jun 2007 10:33:18 -0700
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/54] 2.6.21-stable review
Message-ID: <20070608173318.GA10561@kroah.com>
References: <20070608072127.352723000@sous-sol.org> <20070608172852.GP27332@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608172852.GP27332@redhat.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 01:28:52PM -0400, Dave Jones wrote:
> On Fri, Jun 08, 2007 at 12:21:27AM -0700, Chris Wright wrote:
>  > This is the start of the stable review cycle for the 2.6.21.5 release.
>  > There are 54 patches in this series, all will be posted as a response
>  > to this one.  If anyone has any issues with these being applied, please
>  > let us know.  If anyone is a maintainer of the proper subsystem, and
>  > wants to add a Signed-off-by: line to the patch, please respond with it.
>  > 
>  > These patches are sent out with a number of different people on the
>  > Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
>  > to add your name to the list.  If you want to be off the reviewer list,
>  > also email us.
> 
> I'm wondering if it makes sense to do more regular releases of -stable
> so that the patchqueue doesn't build up so much.   It's painful
> to sit down and review lots of patches in one sitting.
> Additionally, with lots of change, it's a real pain to figure out
> "which one of the 50 patches that went into the last -stable
>  makes my machine not boot"  (which I had to do recently).

It probably does.  Unfortunately I've been traveling _way_ too much
lately and got behind on the patch queue.  I'll try to remember to push
out a new release sooner, as it looks like the majority of my travel is
coming to an end (only 2 trips this month...)

thanks,

greg k-h
