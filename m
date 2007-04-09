Return-Path: <linux-kernel-owner+w=401wt.eu-S965646AbXDIUrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965646AbXDIUrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965393AbXDIUrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:47:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57845 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965646AbXDIUrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:47:12 -0400
Message-ID: <461AA64E.5040109@garzik.org>
Date: Mon, 09 Apr 2007 16:47:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       John Stoffel <john@stoffel.org>
Subject: Re: I give up
References: <200704091007.58535.gene.heskett@gmail.com> <200704091137.01336.gene.heskett@gmail.com> <17946.29660.368403.553290@smtp.charter.net> <200704091549.51805.gene.heskett@gmail.com>            <461A9D42.9000008@garzik.org> <6624.1176150799@turing-police.cc.vt.edu>
In-Reply-To: <6624.1176150799@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Mon, 09 Apr 2007 16:08:34 EDT, Jeff Garzik said:
>> With current hard drive prices (200GB @ US$55, 500GB @ US$120) you can 
>> just keep buying hard drives :)
>>
>> Surely tape price/GB is higher than hard drive price/GB...
> 
> Erm. No.  We're in the middle of installing an StorageTek SL8500 for backups,
> simply because an LTO3 tape holds 300G at a price point of $100 or so.
> And there's no sane way to build a half-petabyte disk farm at that price.
> (And yes, our tape backup service is well into the half-petabyte range, and
> will probably shoot over that as soon as the SL8500 is in production and we
> deal with all the backlogged requests for backup service).
> 
> Don't forget to factor in the cost of disk shelves, power, cooling, and all
> that when you're building something to hold 2,500 200G drives.  Oh. and
> controllers.  And machines to put the controllers in... and all the rest of it.

Who says you have to keep the hard drives plugged into a machine at all 
times?


> And remember - you *dont* want to be backing up critical data on the sort of
> hard drives that cost $55 for 200G - you'll want multiple copies, probably
> some RAID, etc etc.  

The same can be said for tape.  Anyone who only has a single tape backup 
of critical data is an idiot.  Plenty of war stories where such 
scenarios go awry...

	Jeff


