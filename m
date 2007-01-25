Return-Path: <linux-kernel-owner+w=401wt.eu-S965558AbXAYSXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965558AbXAYSXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 13:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965562AbXAYSXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 13:23:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:55801 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965558AbXAYSXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 13:23:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ChtRo4Bv6RfP1284d+LT1bwGUap/Sk5iAepoGA/83WDe97AxiO0dLkWPbAdIKxOaRcADvDqlx9kSnTCtrfMJpcJXsVaf4v+FyZzKoJu7q4TJoj3IiZ5/tv2PMT5bEl2fEjX1eUMW4Tzf03BQubMDYhAAlUn1QBFK3H/n3T+gG44=
Message-ID: <8355959a0701251023l2a0bee33k6d944e48c279686e@mail.gmail.com>
Date: Thu, 25 Jan 2007 23:53:44 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.20-rc6 - eth0 timed out - Myson Enternet driver (PCI)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/07, Sunil Naidu <akula2.shark@gmail.com> wrote:
>
> It was a cool booting, have really enjoyed this.
>

I did find this in my dmesg. I have checked the dmesg of 2.6.19.x &
2.6.20-rc series. This is happening every time.

NETDEV WATCHDOG: eth0: transmit timed out
eth0: Transmit timed out, status 00000000, resetting...
  Rx ring defbf000:  80000000 80000000 80000000 80000000 80000000
80000000 80000000 80000000 80000000 80000000 80000000 80000000
  Tx ring de612000:  80000000 0000 80000000 80000000 80000000 80000000

>
> migration_cost=33 for 2.6.20-rc5
> migration_cost=159 for 2.6.20-rc6
>
> What does this mean?

I shall find it out myself, can't ask more...

>

~Akula2
