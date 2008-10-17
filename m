Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbYJQTpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbYJQTpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 15:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbYJQTpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 15:45:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56453 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750943AbYJQTpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 15:45:45 -0400
Date: Fri, 17 Oct 2008 20:45:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081017204506.0bce46e5@lxorguk.ukuu.org.uk>
In-Reply-To: <20081017174127.GE2221@kroah.com>
References: <20081016002509.GA25868@kroah.com>
	<20081016124943.GE23630@cs181140183.pp.htv.fi>
	<20081016151748.GA31075@kroah.com>
	<20081016153053.GJ5834@nostromo.devel.redhat.com>
	<20081016154726.GA6331@kroah.com>
	<20081016171626.GB22554@cs181140183.pp.htv.fi>
	<20081017040239.GB28188@kroah.com>
	<20081017103138.1ca68d17@lxorguk.ukuu.org.uk>
	<20081017174127.GE2221@kroah.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008 10:41:27 -0700
Greg KH <greg@kroah.com> wrote:

> On Fri, Oct 17, 2008 at 10:31:38AM +0100, Alan Cox wrote:
> > > So I proposed an alternative, YEAR.NUMBER.  The year is easy to keep
> > 
> > Which calendaring system ?
> 
> I'm almost afraid to ask, but "which one would you prefer"? :)

The standard one shipped and supported by util-linux for the past 15 or
more years

$ ddate
Today is Setting Orange, the 71st day of Bureaucracy in the YOLD 3174

