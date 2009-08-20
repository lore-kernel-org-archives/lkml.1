Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbZHTMQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbZHTMQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZHTMQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:16:24 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:24322 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648AbZHTMQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:16:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMzZjEpR9dF4/2dsb2JhbADVfwmEEQWBTg
Date: Thu, 20 Aug 2009 14:16:21 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add watchdog driver for w90p910
Message-ID: <20090820121621.GB29382@infomag.iguana.be>
References: <4A69CE00.10401@gmail.com> <20090804201032.GB30892@infomag.iguana.be> <e68bb3470908050437ma86dddem7621bb7d0da82607@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e68bb3470908050437ma86dddem7621bb7d0da82607@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wan,

> Here is the w90p910 datasheet link, now the ic was renames nuc910.
> Maybe you can give me a good idea,
> hmm, regarding the timer as your mentioned (at91sam9_wdt.c), I am
> studying it and will resubmit a updated patch to you. thanks a lot for
> your help !
> 
> http://www.nuvoton-usa.com/hq/enu/ProductAndSales/ProductLines/ConsumerElectronicsIC/ARMMicrocontroller/ARMMicrocontroller/NUC910A.htm

This is the hardware reference manual. Is there one that describes the registers?

Thanks in advance,
Wim.

