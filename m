Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab0AaXaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 18:30:07 -0500
Received: from z2.cat.iki.fi ([212.16.98.133]:52265 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab0AaXaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 18:30:05 -0500
Date: Mon, 1 Feb 2010 01:30:01 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: A spammer, wanting to poison our bayes seems to have found a
 hole at vger.kernel.org
Message-ID: <20100131233001.GW3486@mea-ext.zmailer.org>
References: <201001302313.19206.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001302313.19206.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 11:13:19PM -0500, Gene Heskett wrote:
> Received: from vger.kernel.org ...
> Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand ...
> Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309Ab0AaENg
> 	(ORCPT <rfc822;linux-kernel-outgoing>);
> 	Sat, 30 Jan 2010 23:13:36 -0500
> Received: from vms173007pub.verizon.net ([206.46.173.7]:39289 "EHLO
...
> Greeting;
> 
> I just noticed that I have a poison bayes spam in my inbox cuz kmails filters 
> haven't a clue what to do with a message addressed like this:
> 
> to:linux-kernel-outgoing@vger.kernel.org
> 
> Is this a leak in the mailing list server, or a total forgery?

Sharp eyes, thanks.

I quoted above Gene's emails Received headers as it travelled thru
vger.kernel.org.  You can have a look at headers of this reply to see,
how many hops it did inside VGER.

There were explicit aliases mapping majordomo output to actual list
expansion.  A smart spammer realized that by adding vger's domain on
them was possible to post directly to list system backend.

Now there is no separate backend, and such aliases no longer exist.

> -- 
> Cheers, Gene

Best Regards,  Matti Aarnio,  one of  <postmaster at vger.kernel.org>
