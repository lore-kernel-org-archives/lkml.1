Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbZJJHtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbZJJHtz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 03:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZJJHtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 03:49:52 -0400
Received: from 1wt.eu ([62.212.114.60]:50135 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbZJJHtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 03:49:52 -0400
Date: Sat, 10 Oct 2009 09:46:26 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [Stable-review] [patch 00/26] 2.6.31.4-stable review
Message-ID: <20091010074626.GE26977@1wt.eu>
References: <20091009231249.GA31084@kroah.com> <20091009233812.GA15982@kroah.com> <20091010071753.GB26977@1wt.eu> <20091010072243.GA27715@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091010072243.GA27715@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 12:22:43AM -0700, Greg KH wrote:
> On Sat, Oct 10, 2009 at 09:17:53AM +0200, Willy Tarreau wrote:
> > On Fri, Oct 09, 2009 at 04:38:12PM -0700, Greg KH wrote:
> > > On Fri, Oct 09, 2009 at 04:12:49PM -0700, Greg KH wrote:
> > > > This is the start of the stable review cycle for the 2.6.31.4 release.
> > > > There are 26 patches in this series, all will be posted as a response to
> > > > this one.  If anyone has any issues with these being applied, please let
> > > > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > > > to add a Signed-off-by: line to the patch, please respond with it.
> > > 
> > > Oops, a bunch of network patches came in right when this went out, and I
> > > don't want to have to wait to get them on, so I've rolled a -rc2 version
> > > now.
> > 
> > Nice! Will you queue them for 2.6.27.38 too ?
> 
> Nope, they were not sent for the .27 tree, only for .31.  If David sends
> me network patches for .27, or people ask me to take specific ones for
> the .27 tree, I'll be glad to queue them up for the next .27 release
> after this one.

OK thanks for this clarification.

Willy

