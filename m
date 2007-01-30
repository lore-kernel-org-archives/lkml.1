Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbXA3Wm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbXA3Wm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbXA3Wm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:42:57 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51251 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbXA3Wm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:42:57 -0500
Message-ID: <45BFC9EF.4060506@garzik.org>
Date: Tue, 30 Jan 2007 17:42:55 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Matthieu CASTET <castet.matthieu@free.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com> <45BFA087.6020905@garzik.org> <loom.20070130T231421-484@post.gmane.org>
In-Reply-To: <loom.20070130T231421-484@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthieu CASTET wrote:
> Jeff Garzik <jeff <at> garzik.org> writes:
> 
>>> And I seem to recall there's more SATA chipset documentation than Jeff
>>> Garzik has time to implement support for.
>> I seriously doubt you can come up with even a single concrete example here.
>>
>> Regardless, libata has 55+ drivers and counting, all for the price of 
>> documentation and hardware.  Another quite strong counter example.
>>
> On another side, some PATA drivers are incomplete or missing.

Which ones are incomplete?

I know a few non-x86 drivers are missing.


> When we switch to PATA and drop old ide stack, what will happen ?
> Will all driver be ported and full-feature, or some will be obsoleted ?

All drivers for which we can find users will be ported.  If any features 
disappear that's a bug.

	Jeff



