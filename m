Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbYHTVFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbYHTVFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757769AbYHTVFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:05:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:41655 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264AbYHTVFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:05:12 -0400
Date: Wed, 20 Aug 2008 14:00:30 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: Re: new driver staged in linux1394-2.6.git
Message-ID: <20080820210030.GA13501@kroah.com>
References: <tkrat.51b6249bb700fa85@s5r6.in-berlin.de> <20080820201106.GC10526@kroah.com> <48AC8167.1020302@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AC8167.1020302@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 10:41:11PM +0200, Stefan Richter wrote:
> Greg KH wrote:
>> On Wed, Aug 20, 2008 at 12:27:40AM +0200, Stefan Richter wrote:
>>> I have harvested the respective patches from Greg KH's staging tree and
>>> added two further updates; more to be added soon.
>> Very nice, thanks for picking this up.
>> Should I drop it from my -staging tree now so that people know to work
>> off of your version?
>
> Yes, since I hope we will get it -next-worthy in linux1394-2.6.git soon.
>
>> This assumes that it will not be dropped by you :)
>
> I'll carry it until mainline merge, unless bigger subsystem changes happen 
> on the v4l-dbv front that make it necessary to move it to their repo.

Great, thanks a lot for doing this, I really appreciate it.

greg k-h
