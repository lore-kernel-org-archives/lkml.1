Return-Path: <linux-kernel-owner+w=401wt.eu-S1752787AbYI2ERp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbYI2ERp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 00:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYI2ERg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 00:17:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34470 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbYI2ERg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 00:17:36 -0400
Message-ID: <48E056DA.4040401@garzik.org>
Date: Mon, 29 Sep 2008 00:17:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH PROPOSAL] libata/pci: Move D3 hack handling from libata
 into PCI
References: <20080724171838.591f6a31@lxorguk.ukuu.org.uk>
In-Reply-To: <20080724171838.591f6a31@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Libata has some hacks to deal with certain controllers going silly in D3
> state. The right way to handle this is to keep a PCI device flag for such
> devices. That can then be generalised for no ATA devices with power
> problems.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>


ACK

