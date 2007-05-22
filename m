Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbXEVEg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbXEVEg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 00:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbXEVEgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 00:36:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48417 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827AbXEVEgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 00:36:20 -0400
Message-ID: <4652733F.4030708@garzik.org>
Date: Tue, 22 May 2007 00:36:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Mike Houston <mikeserv@bmts.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc2
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>	<20070520170506.814a38d9.mikeserv@bmts.com>	<20070521084549.61a1aa71@freepuppy>	<20070521131055.0017404f.mikeserv@bmts.com>	<20070521103755.51b954e1@freepuppy>	<20070521225806.bb18d589.mikeserv@bmts.com> <20070521213146.3e220a44@freepuppy>
In-Reply-To: <20070521213146.3e220a44@freepuppy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> There maybe some hardware level interaction with SATA controller.
> I saw no failures running off i386 kernel of PATA drive and quickly
> see errors with SATA/AHCI and x86_64.


I presume AHCI is the only other device in the system using PCI MSI, 
when you see problems?

	Jeff


