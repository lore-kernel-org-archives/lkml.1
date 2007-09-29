Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbXI2BGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbXI2BGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 21:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757393AbXI2BGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 21:06:18 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60806 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756739AbXI2BGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 21:06:17 -0400
Message-ID: <46FDA503.4000507@garzik.org>
Date: Fri, 28 Sep 2007 21:06:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Martin Michlmayr <tbm@cyrius.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, greg@kroah.com, akpm@osdl.org
Subject: Re: [PATCH][resend] PCI: fix IDE legacy mode resources
References: <20070824115559.06250ec0.yoichi_yuasa@tripeaks.co.jp> <20070824161442.GB15305@kroah.com> <20070824173713.2bc20bac@the-village.bc.nu> <20070928084840.GA5542@derision.cyrius.com> <20070928111408.119f0631@the-village.bc.nu> <20070928101059.GA13826@deprecation.cyrius.com> <46FCD634.7070309@garzik.org> <20070928104754.GA6545@derision.cyrius.com>
In-Reply-To: <20070928104754.GA6545@derision.cyrius.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.7 (---)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-3.7 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Michlmayr wrote:
> * Jeff Garzik <jeff@garzik.org> [2007-09-28 06:23]:
>>>>> Yoichi's original patch and explanation can be found at
>>>>> http://lkml.org/lkml/2007/8/23/411
>>>> I've no idea why it hasn't been applied unless nobody is quite sure who
>>>> owns it. As a PCI fix I guess Greg does (and drop it into -mm for
>>>> testing) ?
>>> I was also hoping Jeff would comment on the patch.
>> What sort of comment were you seeking?  :)
> 
> A comment whether this is the right approach.  You asked for a
> rationale when Yoichi originally submitted the patch in July but then
> never responded to his explanation:
> http://marc.info/?l=linux-kernel&m=118564639820460&w=2

His explanation sounded sane enough :)

	Jeff



