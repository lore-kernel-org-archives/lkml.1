Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbXGKBOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbXGKBOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 21:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbXGKBOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 21:14:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37431 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435AbXGKBOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 21:14:35 -0400
Message-ID: <46942EFA.4080208@garzik.org>
Date: Tue, 10 Jul 2007 21:14:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_sis: FIFO whack
References: <20070525205024.2f83995d@the-village.bc.nu>
In-Reply-To: <20070525205024.2f83995d@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> If you are using a SiS controller and the BIOS didn't set it up then the
> FIFO may be left active when we try and set up the CD. Not convinced this
> matters but I'd prefer to be safe
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

applied


