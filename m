Return-Path: <linux-kernel-owner+w=401wt.eu-S1767168AbXEBWzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767168AbXEBWzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767177AbXEBWzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:55:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57508 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767168AbXEBWzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:55:06 -0400
Date: Wed, 2 May 2007 23:58:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Lord <lkml@rtr.ca>
Cc: Ioan Ionita <opslynx@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       htejun@gmail.com
Subject: Re: More JMicron troubles with 2.6.21
Message-ID: <20070502235851.16936fe5@the-village.bc.nu>
In-Reply-To: <46390781.10507@rtr.ca>
References: <df47b87a0705021037k7dc2d408mcdddbc83daa3b68b@mail.gmail.com>
	<20070502201511.4c8085e9@the-village.bc.nu>
	<46390781.10507@rtr.ca>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The old IDE driver for JMicron didn't work well for me either,
> running on Kubuntu Edgy 2.6.17.  It would find the PATA DVD drive,
> and work okay for the first half of a DVD movie playback, and then go bonkers.

"go bonkers" being ? (and did you keep any dumps of it ?)

> 
> I eventually gave up on it and installed a pure SATA DVD drive on ICH7(8?)
> and just disabled the JMicron completely.


Alan
