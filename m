Return-Path: <linux-kernel-owner+w=401wt.eu-S1030265AbXBTQx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030265AbXBTQx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030266AbXBTQx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:53:26 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45037 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030265AbXBTQxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:53:25 -0500
Message-ID: <45DB2782.7080801@garzik.org>
Date: Tue, 20 Feb 2007 11:53:22 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_cs5520: suspend/resume
References: <20070220174425.43b8975d@localhost.localdomain>
In-Reply-To: <20070220174425.43b8975d@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> The CS5520 isn't just an ATA controller and we must not
> pci_disable_device it as it turns into pci_disable_computer.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

applied


