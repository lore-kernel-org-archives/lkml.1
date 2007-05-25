Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbXEYHNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbXEYHNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbXEYHNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:13:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52273 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbXEYHNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:13:08 -0400
Message-ID: <46568C7C.70608@garzik.org>
Date: Fri, 25 May 2007 03:13:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Henry Su <henry.su@amd.com>
CC: alan@lxorguk.ukuu.org.uk, greg@kroah.com, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       xiaosuzi520@hotmail.com
Subject: Re: [patch] Add the device IDs for AMD/ATI SB700
References: <FFECF24D2A7F6D418B9511AF6F35860201AEFB7F@shacnexch2.atitech.com>
In-Reply-To: <FFECF24D2A7F6D418B9511AF6F35860201AEFB7F@shacnexch2.atitech.com>
Content-Type: text/plain; charset=UTF-7
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henry Su wrote:
>  Hi Jeff,
> Thanks for your kindly help, I will fix the email next time.
> Do you mean all the device IDs for ATI SB700 are added to the corresponding files?
> because I split this patch and resent four patches according to your last suggestion,
> if this patch is applied, another patches are  not necessary now.

Splitting up the patches helped us all.  The AHCI, drivers/ide, and now
pata_atiixp patches were applied by the respective maintainers.  Let me
know if you need a quick introduction to git, which is the main tool to
watch the latest Linux kernel source code (it's like CVS, but better :))

I don't know about the SMBus patch, though.  That may or may not have
been applied.

	Jeff



