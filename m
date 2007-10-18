Return-Path: <linux-kernel-owner+w=401wt.eu-S1764341AbXJRA7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764341AbXJRA7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbXJRA7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:59:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33993 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388AbXJRA7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:59:02 -0400
Message-ID: <4716AFD4.4040205@garzik.org>
Date: Wed, 17 Oct 2007 20:59:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Sonic Zhang <sonic.adi@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux IDE <linux-ide@vger.kernel.org>, bzolnier@gmail.com
Subject: Re: [PATCH] Update libata driver for bf548 atapi controller against
 the 2.6.24 tree.
References: <1192524207.11166.1.camel@sevens.analog.com>
In-Reply-To: <1192524207.11166.1.camel@sevens.analog.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sonic Zhang wrote:
> Changes:
> 1. Remove irq_ack() and port_disable() methods
> 2. Acocomodate for the libata-link patches
> 3. Change Kconfig ATAPI mode option into a module param.
> 4. Add supported WMDMA mode.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

applied


