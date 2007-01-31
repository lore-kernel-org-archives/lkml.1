Return-Path: <linux-kernel-owner+w=401wt.eu-S1030522AbXAaScL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030522AbXAaScL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030526AbXAaScK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:32:10 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:53161 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030522AbXAaScJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:32:09 -0500
Date: Wed, 31 Jan 2007 19:29:27 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: alan <alan@clueserver.org>
cc: Roland Dreier <rdreier@cisco.com>, Greg KH <greg@kroah.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
In-Reply-To: <Pine.LNX.4.64.0701310956540.8343@blackbox.fnordora.org>
Message-ID: <Pine.LNX.4.61.0701311927170.13737@yvahk01.tjqt.qr>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
 <20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>
 <45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com>
 <20070130214759.GA12477@kroah.com> <adar6tcp43r.fsf@cisco.com>
 <Pine.LNX.4.61.0701311849490.13737@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0701310956540.8343@blackbox.fnordora.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 31 2007 09:58, alan wrote:
> On Wed, 31 Jan 2007, Jan Engelhardt wrote:
>> On Jan 30 2007 14:00, Roland Dreier wrote:
>> > 
>> > An uncharitable vendor might decide it's not worth publishing specs,
>> > since the Linux guys can reverse engineer the Windows driver just as
>> > fast anyway.
>> 
>> And ndiswrapper gives fire to just releasing the Windows one :(
>
> ndiswrapper is a way to make it work "now" as opposed to "correct". 
> There is a lot that you cannot do with ndiswrapper that a proper driver
> can.

The fear is that a vendor might not open things because it works
"reasonably enough" (for them as well as the enduser) at "this time".
E.g. I got sis162u.inf for some usb wireless adapter, it works
enough, but of course I am not too happy with the binary blob because
it might have some not-so-"correct" core that could silently oops me
away.



Jan
-- 
