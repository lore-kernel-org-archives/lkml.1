Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbZJJHYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbZJJHYm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 03:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZJJHYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 03:24:41 -0400
Received: from 1wt.eu ([62.212.114.60]:50116 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783AbZJJHYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 03:24:41 -0400
Date: Sat, 10 Oct 2009 09:17:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [patch 00/26] 2.6.31.4-stable review
Message-ID: <20091010071753.GB26977@1wt.eu>
References: <20091009231249.GA31084@kroah.com> <20091009233812.GA15982@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009233812.GA15982@kroah.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 04:38:12PM -0700, Greg KH wrote:
> On Fri, Oct 09, 2009 at 04:12:49PM -0700, Greg KH wrote:
> > This is the start of the stable review cycle for the 2.6.31.4 release.
> > There are 26 patches in this series, all will be posted as a response to
> > this one.  If anyone has any issues with these being applied, please let
> > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > to add a Signed-off-by: line to the patch, please respond with it.
> 
> Oops, a bunch of network patches came in right when this went out, and I
> don't want to have to wait to get them on, so I've rolled a -rc2 version
> now.

Nice! Will you queue them for 2.6.27.38 too ?

Willy

