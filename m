Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbZGAQop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbZGAQop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZGAQoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:44:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48821 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZGAQoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:44:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A4B9228.8080503@s5r6.in-berlin.de>
Date: Wed, 01 Jul 2009 18:43:20 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090523 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Julien BLACHE <jb@jblache.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>, Greg KH <gregkh@suse.de>,
       felixb@sgi.com, linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [patch 000/108] 2.6.30-stable review
References: <20090701002838.GA7100@kroah.com>	<87tz1wd4vi.fsf@sonic.technologeek.org>	<4A4B7A77.8010208@s5r6.in-berlin.de>	<87hbxwcswp.fsf@sonic.technologeek.org>	<43e72e890907010922t7bd80108xa3caaf4decfd87a6@mail.gmail.com> <87d48kcqsk.fsf@sonic.technologeek.org>
In-Reply-To: <87d48kcqsk.fsf@sonic.technologeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julien BLACHE wrote:
> "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
> 
> Hi,
> 
>>> Actually I was under the impression that the proper request had been
>>> made for inclusion into -stable, but it looks like it's not been done
>>> after all.
>>>
>>> So, here goes.
>> Better inline.

The previous posting can be quilt-imported and git-am'ed as is.  Having 
the diff inline rather than attached would be nicer if it was a 
submission for review, but this was obviously just meant to be enqueued 
for the next stable review round by the -stable maintainers (who will 
repost it for review when it's time).

> Crap, I got tricked by the inline thing again. Sorry, properly inlined
> this time.

Uh oh, you inlined it after the '-- ' signature delimiter; responders 
can't quote it. ;-)
-- 
Stefan Richter
-=====-==--= -=== ----=
http://arcgraph.de/sr/
