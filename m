Return-Path: <linux-kernel-owner+w=401wt.eu-S932507AbXF1Xsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507AbXF1Xsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbXF1Xsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:48:32 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49294 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524AbXF1Xsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:48:31 -0400
Message-ID: <468448B4.6060301@zytor.com>
Date: Thu, 28 Jun 2007 19:48:04 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Wilcox <matthew@wil.cx>,
       Matt Domsch <Matt_Domsch@dell.com>, lkml <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] PCI: limit pci_get_bus_and_slot to domain 0
References: <20070626132622.3226261a.randy.dunlap@oracle.com>	<20070627024505.GA30197@humbolt.us.dell.com>	<20070627113048.GU22063@parisc-linux.org>	<20070627145500.2e66fd49@the-village.bc.nu>	<46829345.1000607@zytor.com>	<20070627165429.GY22063@parisc-linux.org>	<20070627182518.50423241@the-village.bc.nu>	<4682AD9B.9060105@zytor.com> <20070628160421.141c4178.randy.dunlap@oracle.com>
In-Reply-To: <20070628160421.141c4178.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> 
> Is this what you mean?

Yup.

Acked-by: H. Peter Anvin <hpa@zytor.com>
