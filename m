Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbXF3UGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbXF3UGt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 16:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbXF3UGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 16:06:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38002 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbXF3UGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 16:06:40 -0400
Message-ID: <4686B7CD.2020404@garzik.org>
Date: Sat, 30 Jun 2007 16:06:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Charles Shannon Hendrix <shannon@widomaker.com>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: SATA/ADMA TIMEOUTS, dmesg output
References: <4686A32F.1010700@widomaker.com>
In-Reply-To: <4686A32F.1010700@widomaker.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Charles Shannon Hendrix wrote:
> 
> 
> Following this post is output from Linux kernel 2.6.21 showing ADMA 
> timeouts.
> 
> 2.6.21 has improved the situation over earlier kernels, but the problems 
> do still occur.
> 
> nforce4 chipset, Seagate Barracuda SATA drives.
> 
> This is meant mainly as an additional data point in case it helps 
> someone debug the problem.

Does setting 'adma' module option to zero fix things?

	Jeff



