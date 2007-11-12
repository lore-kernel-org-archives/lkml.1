Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbXKLHax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbXKLHax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 02:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbXKLHap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 02:30:45 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:35848 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbXKLHao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 02:30:44 -0500
Date: Mon, 12 Nov 2007 02:27:40 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] log2.h: Define order_base_2() macro for convenience.
In-Reply-To: <20071111102837.e934544d.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.0.9999.0711120227010.9407@localhost.localdomain>
References: <Pine.LNX.4.64.0711102249110.7449@localhost.localdomain> <20071111102837.e934544d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 11 Nov 2007, Randy Dunlap wrote:

> On Sat, 10 Nov 2007 22:53:36 -0500 (EST) Robert P. J. Day wrote:
> >
> > +/**
> > + * order_base_2 - calculate the (rounded up) base 2 order of the argument
> > + * @n - parameter
>
>  * @n: argument
>
> (mostly changing - to :)

ah, yes, fix coming shortly.

rday
