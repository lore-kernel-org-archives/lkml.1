Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbXIWXrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbXIWXrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 19:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbXIWXrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 19:47:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46665 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbXIWXrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 19:47:04 -0400
Message-ID: <46F6FAF6.5090604@garzik.org>
Date: Sun, 23 Sep 2007 19:47:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: dougg@torque.net
CC: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Broadcom 8603 SAS/SATA driver, rough draft
References: <20070923040437.GA30170@havoc.gtf.org> <46F6E1C2.20905@torque.net> <46F6FAC4.2020509@garzik.org>
In-Reply-To: <46F6FAC4.2020509@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Just for everybody's information, the Marvell SAS/SATA chip for which 
> I'm also writing a driver definitely supports all of that:  SMP, STP, 
> wire ports, SCSI target mode, even SATA target mode.

s/wire/wide/ of course

