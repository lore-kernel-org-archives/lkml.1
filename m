Return-Path: <linux-kernel-owner+w=401wt.eu-S932088AbXGFUoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbXGFUoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764159AbXGFUn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:43:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59058 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764155AbXGFUn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:43:56 -0400
Message-ID: <468EA987.80001@garzik.org>
Date: Fri, 06 Jul 2007 16:43:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Thorsten Leemhuis <fedora@leemhuis.info>
CC: Chr <chunkeey@web.de>, "Gaston, Jason D" <jason.d.gaston@intel.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2.6.22-rc6] ATA: add a PCI ID for Intel Santa Rosa PATA
 controller
References: <39B20DF628532344BC7A2692CB6AEE070181E0EA@orsmsx420.amr.corp.intel.com> <200707062145.01928.chunkeey@web.de> <468E9F9C.9010508@leemhuis.info>
In-Reply-To: <468E9F9C.9010508@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thorsten Leemhuis wrote:
> But anyway: Sorry, am I the only one that gets nervous if we start to
> run a ATA-Hardware (Intels recent ICH southbridges in this case) with a
> speed grade (Ultra ATA/133) that is not specified by its manufacturer in
> his public data sheets (Ultra ATA/100 max)?

That's why the patch I applied referenced ATA/100...

If they fix the datasheets, we can always upgrade it later.

	Jeff


