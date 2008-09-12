Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbYILOdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbYILOdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 10:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYILOcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 10:32:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57466 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbYILOcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 10:32:51 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: David Woodhouse <dwmw2@infradead.org>
To: Joseph Fannin <jfannin@gmail.com>
Cc: Greg KH <greg@kroah.com>, Marcel Holtmann <marcel@holtmann.org>,
       Thierry Vignaud <tvignaud@mandriva.com>,
       David Miller <davem@davemloft.net>, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20080912083927.GA13849@nineveh.local>
References: <20080910.160505.14060698.davem@davemloft.net>
	 <m27i9i9az9.fsf@vador.mandriva.com> <20080911134042.GB3293@kroah.com>
	 <1221151165.6309.55.camel@californication>
	 <20080911201541.GA18518@kroah.com>
	 <1221165518.4077.17.camel@macbook.infradead.org>
	 <20080911205738.GB11708@kroah.com>
	 <1221167725.4077.34.camel@macbook.infradead.org>
	 <20080911220700.GD5823@kroah.com>
	 <1221171943.4077.59.camel@macbook.infradead.org>
	 <20080912083927.GA13849@nineveh.local>
Content-Type: text/plain
Date: Fri, 12 Sep 2008 07:32:44 -0700
Message-Id: <1221229964.3919.38.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-12 at 04:39 -0400, Joseph Fannin wrote:
> On Thu, Sep 11, 2008 at 03:25:43PM -0700, David Woodhouse wrote:
> > On Thu, 2008-09-11 at 15:07 -0700, Greg KH wrote:
> <snip>
> 
> > Now, can we _please_ stop being bloody stupid? If there are _real_
> > problems, like the one I fixed with commit 1cede1af last week, then I'm
> > perfectly happy to deal with them. But stop making crap up.
> 
> I CAN'T INSTALL MORE THAN ONE KERNEL PACKAGE > v2.6.26.
> 
> IT'S NOT IMAGINARY.
> 
> IT USED TO WORK AND YOU BROKE IT.

Then your kernel packaging is broken. Fix it.

Or go an stand in the corner with the muppets who are whining that the
move from arch/i386 to arch/x86 also broke their kernel packaging....
and who refuse to fix that too.

Oh, wait...there weren't any of those; it wasn't even a _consideration_.

You're just being an idiot, because people like to whine about firmware.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

