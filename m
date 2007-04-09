Return-Path: <linux-kernel-owner+w=401wt.eu-S933413AbXDIOrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbXDIOrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933449AbXDIOrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:47:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54795 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933413AbXDIOrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:47:35 -0400
Message-ID: <461A5204.1050206@garzik.org>
Date: Mon, 09 Apr 2007 10:47:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: I give up
References: <200704091007.58535.gene.heskett@gmail.com>
In-Reply-To: <200704091007.58535.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Now the 64k$ question: While running with LVM2 managed disks, is it 
> possible to run without dm_mod, the device-mapper?  If so, please tell me 
> how to achieve this.

No; device mapper is the kernel portion of LVM2.

	Jeff, who actively avoids LVM on home computers




