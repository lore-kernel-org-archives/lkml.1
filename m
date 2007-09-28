Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbXI1Ksi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbXI1Ksi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 06:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755946AbXI1Ks1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 06:48:27 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:1548 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbXI1Ks0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 06:48:26 -0400
Date: Fri, 28 Sep 2007 12:47:54 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, greg@kroah.com, akpm@osdl.org
Subject: Re: [PATCH][resend] PCI: fix IDE legacy mode resources
Message-ID: <20070928104754.GA6545@derision.cyrius.com>
References: <20070824115559.06250ec0.yoichi_yuasa@tripeaks.co.jp> <20070824161442.GB15305@kroah.com> <20070824173713.2bc20bac@the-village.bc.nu> <20070928084840.GA5542@derision.cyrius.com> <20070928111408.119f0631@the-village.bc.nu> <20070928101059.GA13826@deprecation.cyrius.com> <46FCD634.7070309@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FCD634.7070309@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeff Garzik <jeff@garzik.org> [2007-09-28 06:23]:
>>>> Yoichi's original patch and explanation can be found at
>>>> http://lkml.org/lkml/2007/8/23/411
>>> I've no idea why it hasn't been applied unless nobody is quite sure who
>>> owns it. As a PCI fix I guess Greg does (and drop it into -mm for
>>> testing) ?
>> I was also hoping Jeff would comment on the patch.
>
> What sort of comment were you seeking?  :)

A comment whether this is the right approach.  You asked for a
rationale when Yoichi originally submitted the patch in July but then
never responded to his explanation:
http://marc.info/?l=linux-kernel&m=118564639820460&w=2

-- 
Martin Michlmayr
http://www.cyrius.com/
