Return-Path: <linux-kernel-owner+w=401wt.eu-S1750878AbXC1C5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878AbXC1C5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 22:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbXC1C5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 22:57:32 -0400
Received: from mail2.ics.ntts.co.jp ([202.32.24.42]:34062 "EHLO
	mail2.ics.ntts.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbXC1C5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 22:57:31 -0400
Date: Wed, 28 Mar 2007 10:36:43 +0900 (JST)
Message-Id: <20070328.103643.189728305.takamiya@po.ntts.co.jp>
TO: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
CC: usagi-core@linux-ipv6.org
Subject: Re: (usagi-core 32652) Re: [linux-usb-devel] [PATCH 0/2] [SERIAL]
 [USB] fixed to skip NULL entry in struct serial usb_serial_port.
From: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>
In-Reply-To: <20070327225139.GE4478@kroah.com>
References: <20070325155521.GA11663@kroah.com>
	<20070326.093815.465778826.takamiya@po.ntts.co.jp>
	<20070327225139.GE4478@kroah.com>
X-Face: +<)&j!Ce24nM@a.\f6TA,]^9Q76[_QN_[QR-(bT&>b40Oo[:`R(>b7!b-|q5k&.8CO[_Oh_
 !9Nk0rikK70~?|08EFH|:]iF6pwPlnfEn-wo-voY:rP?%7p%cxjnbf'hglO'se&QwZN7/RVX!U7*P%
 cTV('HfHp+?g1+hx7\+J.W]<O~hbwx[4hPPO=T<7aV2^7["&p^h4:YbY6,bS,ecZ7S5<pIUTnT''}k
 ={TEs)bN%-8Jdo~.Q_lpa-fN^.Fo9dFB*}\@=PK@0pmvZ3k0p-5hMQ<bjyK{enk/sOQ[<(k]}Q\p>G
 zYWv%LsDc
X-Mailer: Mew version 5.1 on XEmacs 21.4.17 (Jumbo Shrimp)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Tue, 27 Mar 2007 15:51:39 -0700
>> [Subject: (usagi-core 32652) Re: [linux-usb-devel] [PATCH 0/2] [SERIAL] [USB] fixed to skip NULL entry in struct serial usb_serial_port.]
>> Greg KH <greg@kroah.com> wrote...

> >   I think so. But I wonder if usb_get_serial_port_data() should check
> >   the argument for the other drivers.
> 
> I don't think it is really necessary, do you?

  I see.

--
Noriaki TAKAMIYA
