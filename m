Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbZBNUxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbZBNUxb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 15:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZBNUxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 15:53:22 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48044 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbZBNUxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 15:53:21 -0500
Message-ID: <49972F3C.2090800@garzik.org>
Date: Sat, 14 Feb 2009 15:53:16 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Serguei Miridonov <mirsev@cicese.mx>
CC: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: Intel ICH9M/M-E SATA error-handling/reset problems
References: <200902141206.06419.mirsev@cicese.mx>
In-Reply-To: <200902141206.06419.mirsev@cicese.mx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serguei Miridonov wrote:
> I have some problems with SATA in a new notebook PC (HP Pavilion dv5t, 
> Intel chipset). Seagate FreeAgent Pro 1TB external drive practically 
> can not be used with eSATA in Linux (fresh install from DVD Fedora 10, 
> now fully updated), and yesterday I also had problem with DVD 
> recording using internal HL-DT-ST BDDVDRW drive.

Some eSata fixes went into the more-recent kernels...  Can you try 
2.6.29-rc5?

	Jeff



