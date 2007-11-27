Return-Path: <linux-kernel-owner+w=401wt.eu-S1757351AbXK0BjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbXK0BjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 20:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbXK0BjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 20:39:15 -0500
Received: from stinky.trash.net ([213.144.137.162]:40841 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520AbXK0BjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 20:39:15 -0500
Message-ID: <474B753C.7060303@trash.net>
Date: Tue, 27 Nov 2007 02:39:08 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: kloczek@rudy.mif.pg.gda.pl
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.9
References: <20071126180132.GA25230@kroah.com> <Pine.BSO.4.63.0711270211090.18832@rudy.mif.pg.gda.pl>
In-Reply-To: <Pine.BSO.4.63.0711270211090.18832@rudy.mif.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz K wrote:
> On Mon, 26 Nov 2007, Greg Kroah-Hartman wrote:
> [..]
>
> Still there is no aroud officialy released iptables tarball with 
> support for rules for new xt_{connlimit,time,u32} modules.
> Anyone know where are patches for manage connlimit, time, u32 rules 
> which will be included in next release ?

A well chosen thread to ask this question. xt_time is not even
included in 2.6.23.

http://netfilter.org/news.html#2007-10-15
