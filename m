Return-Path: <linux-kernel-owner+w=401wt.eu-S1752261AbXCYFrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbXCYFrt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 01:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbXCYFrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 01:47:49 -0400
Received: from linux6.nezu.wide.ad.jp ([203.178.142.218]:53323 "EHLO
	nezu.linux-ipv6.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbXCYFrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 01:47:48 -0400
Date: Sun, 25 Mar 2007 14:47:40 +0900 (JST)
Message-Id: <20070325.144740.432839277.takamiya@linux-ipv6.org>
To: usagi-core@linux-ipv6.org, greg@kroah.com
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: (usagi-core 32638) Re: [linux-usb-devel] [PATCH 0/2] [SERIAL]
 [USB] fixed to skip NULL entry in struct serial usb_serial_port.
From: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>
In-Reply-To: <20070324212253.GA26215@kroah.com>
References: <20070325.005227.432838064.takamiya@linux-ipv6.org>
	<20070324212253.GA26215@kroah.com>
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

Hi,

>> Sat, 24 Mar 2007 14:22:53 -0700
>> [Subject: (usagi-core 32638) Re: [linux-usb-devel] [PATCH 0/2] [SERIAL] [USB] fixed to skip NULL entry in struct serial usb_serial_port.]
>> Greg KH <greg@kroah.com> wrote...

> This should already be fixed in the -git snapshots that have come out
> after 2.6.21-rc4.  Can you test them to verify this?

  Yes, this problem was already fixed.

  Thanks.

--
Noriaki TAKAMIYA
