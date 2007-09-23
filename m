Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbXIWXeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbXIWXeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 19:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbXIWXeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 19:34:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41831 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbXIWXd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 19:33:59 -0400
Message-ID: <46F6F7E5.6040100@garzik.org>
Date: Sun, 23 Sep 2007 19:33:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: dougg@torque.net
CC: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Broadcom 8603 SAS/SATA driver, rough draft
References: <20070923040437.GA30170@havoc.gtf.org> <46F6E1C2.20905@torque.net>
In-Reply-To: <46F6E1C2.20905@torque.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Douglas Gilbert wrote:
> Is the lack of SMP support a driver limitation or is it
> the silicon?

Open question (pending w/ BCM).  It looks like the answer is "silicon 
limitation".


> How about support for wide ports

Open question (w/ BCM).  It looks like the answer is "no support."


> Last question: can the chip run in SCSI target mode?

AFAICT, no.

	Jeff


