Return-Path: <linux-kernel-owner+w=401wt.eu-S1763140AbXEPTYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763140AbXEPTYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762658AbXEPTYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:24:01 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:48890 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762199AbXEPTYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:24:00 -0400
Date: Wed, 16 May 2007 21:21:40 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
cc: Jeff Garzik <jeff@garzik.org>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
In-Reply-To: <464B58A2.6010202@mnsu.edu>
Message-ID: <Pine.LNX.4.61.0705162118560.9019@yvahk01.tjqt.qr>
References: <20070516144205.GV26766@think.oraclecorp.com>
 <Pine.LNX.4.61.0705162010370.9019@yvahk01.tjqt.qr> <464B57B7.7090404@garzik.org>
 <464B58A2.6010202@mnsu.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 16 2007 14:16, Jeffrey Hundstad wrote:
> Jeff Garzik wrote:
>> Jan Engelhardt wrote:
>> > On May 16 2007 10:42, Chris Mason wrote:
>> > > For example, I'll pick on xfs for a minute.  compilebench shows
>> > > the
>> > > default FS you get from mkfs.xfs is pretty slow for untarring a
>> > > bunch of
>> > > kernel trees.
>> > 
>> > I suppose you used 'nobarrier'? [ http://lkml.org/lkml/2006/5/19/33 ]
>> 
>> Shouldn't that option be renamed to 'corrupt_my_data'?  ;-)
>
> Perhaps maybe "my_power_never_fails".

It's not like I live in a country where power regularly fails.


	Jan
-- 
