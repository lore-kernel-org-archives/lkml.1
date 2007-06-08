Return-Path: <linux-kernel-owner+w=401wt.eu-S966477AbXFHPz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966477AbXFHPz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932836AbXFHPzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:55:06 -0400
Received: from havoc.gtf.org ([69.61.125.42]:57477 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938935AbXFHPzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:55:03 -0400
Date: Fri, 8 Jun 2007 11:55:02 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] Re: Linux v2.6.22-rc3
Message-ID: <20070608155502.GH25649@havoc.gtf.org>
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org> <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com> <466196AD.3090502@garzik.org> <9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com> <46667466.4010500@gmail.com> <9d2cd630706062322v2d73b32dp1da56f97e2069fff@mail.gmail.com> <4667B347.9040900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4667B347.9040900@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I just confirmed that two PATA-era major BIOS brands do SRST.  They do
check for the device signature in TF registers...  but only for the ATA
device signature.

	Jeff



