Return-Path: <linux-kernel-owner+w=401wt.eu-S1760791AbXGCPnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760791AbXGCPnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760385AbXGCPnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:43:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33109 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760291AbXGCPnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:43:24 -0400
Message-ID: <468A6E99.5060302@garzik.org>
Date: Tue, 03 Jul 2007 11:43:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: Support chips with 64K PRD quirk
References: <20070703160502.685fede6@the-village.bc.nu>
In-Reply-To: <20070703160502.685fede6@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Add ata_dumb_qc_prep and supporting logic so that a driver can just
> specify it needs to be helped in this area. 64K entries are split
> as with drivers/ide.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

ACK, modulo comment just sent


