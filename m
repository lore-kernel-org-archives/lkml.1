Return-Path: <linux-kernel-owner+w=401wt.eu-S1751757AbXBQU1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbXBQU1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 15:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXBQU1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 15:27:15 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47745 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbXBQU1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 15:27:13 -0500
Message-ID: <45D76518.7080201@garzik.org>
Date: Sat, 17 Feb 2007 15:27:04 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Richard Knutsson <ricknu-0@student.ltu.se>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Andrew Morton <akpm@osdl.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/wan/pc300too.c: pci_module_init to pci_register_driver
References: <20070214004022.4455.49724.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20070214004022.4455.49724.sendpatchset@thinktank.campus.ltu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Knutsson wrote:
> Convert pci_module_init() to pci_register_driver().
> 
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> Compile-tested with "allyes", "allmod" & "allno" on i386

applied


