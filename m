Return-Path: <linux-kernel-owner+w=401wt.eu-S932235AbXAVWjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbXAVWjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 17:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932247AbXAVWjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 17:39:09 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43073 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235AbXAVWjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 17:39:07 -0500
Message-ID: <45B53D05.1010807@garzik.org>
Date: Mon, 22 Jan 2007 17:39:01 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] ide: fix UDMA/MWDMA/SWDMA masks
References: <20070119003058.14846.43637.sendpatchset@localhost.localdomain>	<20070119003226.14846.87052.sendpatchset@localhost.localdomain>	<45B4FFBD.40507@ru.mvista.com>	<20070122184620.1c8b87ac@localhost.localdomain>	<45B51E83.1010904@ru.mvista.com> <20070122213109.21e4e805@localhost.localdomain>
In-Reply-To: <20070122213109.21e4e805@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> Wouldn't mind the older 64x (not 640) data sheets if they are sharable.


If they are sharable, I would love to archive them at

	http://gkernel.sourceforge.net/specs/

Regards,

	Jeff


