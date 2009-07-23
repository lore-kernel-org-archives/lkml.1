Return-Path: <linux-kernel-owner+w=401wt.eu-S1752533AbZGWOg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbZGWOg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZGWOg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:36:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48985 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbZGWOg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:36:27 -0400
From: "Pandita, Vikram" <vikram.pandita@ti.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Eric Whitney <eric.whitney@hp.com>, Rich Freiss <richard.freiss@hp.com>,
       Linux OMAP Users <linux-omap@vger.kernel.org>
Date: Thu, 23 Jul 2009 20:06:01 +0530
Subject: RE: Boot Hang - mmotm 090716 - serial 8250 irq flags support
Thread-Topic: Boot Hang - mmotm 090716 - serial 8250 irq flags support
Thread-Index: AcoLnXn9vnsUSli4SfCQN94bhCu4PwABTXAQ
Message-ID: <FCCFB4CDC6E5564B9182F639FC35608702F57AD326@dbde02.ent.ti.com>
References: <1248291948.4490.67.camel@useless.americas.hpqcorp.net>
	<20090723113353.7da8f6f9@lxorguk.ukuu.org.uk>
	<1248353462.5674.80.camel@useless.americas.hpqcorp.net>
 <20090723145754.3f001c4e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090723145754.3f001c4e@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan

>-----Original Message-----
>From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
>Sent: Thursday, July 23, 2009 8:58 AM
>To: Lee Schermerhorn
>Cc: Andrew Morton; Pandita, Vikram; Alan Cox; linux-kernel; Bjorn Helgaas; Eric Whitney; Rich Freiss
>
>> </system1>hpiLO-> Virtual Serial Port active: IO=0x02F8 INT=3
>>
>> Perhaps Bjorn or Rich could comment on the hardware setup...
>
>Ok thats a generic ISA port
>
>The rest fits the patch I sent you so hopefully that fixes it and if so
>I'll make sure the corrected one ends up in -next.

Are you referring to serial-add-irqflags-support patch.
Do let me know in case any respin of this patch is needed.

>
>Alan

