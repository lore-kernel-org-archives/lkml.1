Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbYJ1TEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbYJ1TEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYJ1TEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:04:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43451
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbYJ1TEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:04:42 -0400
Date: Tue, 28 Oct 2008 12:04:19 -0700 (PDT)
Message-Id: <20081028.120419.252131562.davem@davemloft.net>
To: donner@dbd-breitband.de
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: tg3:No interrupt was generated using MSI, switching to INTx
 mode. Please report this failure to the PCI maintainer and include system
 chipset information.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1225191510.26840.6.camel@localhost>
References: <1225191510.26840.6.camel@localhost>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marc Donner <donner@dbd-breitband.de>
Date: Tue, 28 Oct 2008 11:58:30 +0100

Please report networking problems to netdev@vger.kernel.org
(added to CC:)

Many networking developers do not read linux-kernel

> Hi @all,
> 
> we have installed a dual port Brodcam Gigabit Ethernet NIC, and get the
> following error in dmesg:
> 
> tg3: eth1 No interrupt was generated using MSI, switching to INTx mode.
> Please report this failure to the PCI maintainer and include system
> chipset information.
> 
> Who is responsible for this error message? We are using Kernel 2.6.21.1
> and the NIC Chipset is a Broadcom BCM5715CKPBG
> 
> Regards,
> 
> Marc
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
