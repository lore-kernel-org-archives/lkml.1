Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbXI3QET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbXI3QET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 12:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757379AbXI3QEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 12:04:09 -0400
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:56778 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097AbXI3QEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 12:04:08 -0400
Date: Sun, 30 Sep 2007 18:03:56 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] blacklist NCQ on Seagate Barracuda ST380817AS
Message-ID: <20070930180356.45d0c428@localhost>
In-Reply-To: <46FFC7F1.6080409@garzik.org>
References: <20070930160548.235be972@localhost>
	<20070930152908.1f58d39d@the-village.bc.nu>
	<20070930164610.20818867@localhost>
	<46FFBB2D.6060004@garzik.org>
	<20070930172859.7fd44eab@localhost>
	<46FFC42A.9080300@garzik.org>
	<20070930175207.5bfa89a8@localhost>
	<46FFC7F1.6080409@garzik.org>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Sep 2007 11:59:45 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Is libata built into the kernel, or a module?

built-in, my kernel is pretty monolithic

-- 
	Paolo Ornati
	Linux 2.6.23-rc8-ga64314e6 on x86_64
