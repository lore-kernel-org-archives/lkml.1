Return-Path: <linux-kernel-owner+w=401wt.eu-S1753178AbYIYHuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbYIYHuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 03:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYIYHtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 03:49:55 -0400
Received: from ptb-relay03.plus.net ([212.159.14.147]:45878 "EHLO
	ptb-relay03.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYIYHty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 03:49:54 -0400
Message-ID: <48DB429C.4050904@yahoo.com>
Date: Thu, 25 Sep 2008 08:49:48 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: =?UTF-8?B?UGF3ZcWCIFNpa29yYQ==?= <pluto@agmk.net>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [kernel-abi] symbol versioning vs. out-of-tree modules.
References: <Y165ES5i.1222268879.9618400.pluto@agmk.net> <20080925024840.GA14575@kroah.com> <200809250829.22294.pluto@agmk.net>
In-Reply-To: <200809250829.22294.pluto@agmk.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Plusnet-Relay: 5cd476a50e94034bcc11c3d035e8df0e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paweł Sikora wrote:
> On Thursday 25 of September 2008 04:48:40 Greg KH wrote:
>> What kernel modules do you currently use/rely on that are not in the
>> main kernel tree?  Do you have links to them?  I'd be glad to add them.
> 
> here's a quick list:
> 
> - http://www.lirc.org

^^^^ People are taking steps to adapt this to be included in kernel. See 
  http://lwn.net/Articles/297770/ . I could have sworn I saw someone 
posting an input layer patch for lirc the other day too... Aha - 
http://lkml.org/lkml/2008/9/24/328 .

> - http://rt2x00.serialmonkey.com

Isn't this one already in the wireless tree? I believe it was merged in 
2.6.24 - 
http://kernelnewbies.org/Linux_2_6_24#head-62e9ebf067c978bbf70898986c0aa3904d1a3543 
.

> - http://aufs.sourceforge.net

I've read rumblings about one of the stacking FSes being merged but thus 
far nothing seems to have happened - http://lwn.net/Articles/265240/ .

> - http://linux-uvc.berlios.de

USB video has already been merged into mainline in 2.6.25 - 
http://kernelnewbies.org/Linux_2_6_26#head-6d4ee1ddea983f5c8ac491b8685a94ea6fa4132b 
! I'm using it on my eeepc...

Those are the ones I recognise off the top of my head. I'll have to 
search with regard to the other ones you mentioned...

-- 
Sitsofe | http://sucs.org/~sits/
