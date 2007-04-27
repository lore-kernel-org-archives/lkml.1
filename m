Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbXD0X46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbXD0X46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbXD0X46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:56:58 -0400
Received: from gherkin.frus.com ([192.158.254.49]:50557 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757924AbXD0X45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:56:57 -0400
Subject: Re: BAD_SG_DMA panic in aha1542
In-Reply-To: <20070427231346.647797bc@the-village.bc.nu> "from Alan Cox at Apr
 27, 2007 11:13:46 pm"
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 27 Apr 2007 18:56:56 -0500 (CDT)
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070427235656.B767BDBA2@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> > As before, no problems using the sda hard disk (which is the boot drive):
> > everything works reliably until I touch the cdrom drive.
> 
> A little quiet contemplation and gnome number 387 suggests trying the following
> (and providing more detailed information such as the last message printed before
> the DMA message). Stuff a BUG() before the panic in BAD_DMA (aha1542.c) if needed
> to get a good trace.
> 
> Please report success/failure/change.

Can do.  I don't have access to the machine on weekends, so it will be
at least Monday before I can give this a whirl.  Thanks!

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
