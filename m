Return-Path: <linux-kernel-owner+w=401wt.eu-S933413AbXBCBXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbXBCBXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 20:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933409AbXBCBXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 20:23:43 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:26500 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404AbXBCBXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 20:23:42 -0500
Date: Fri, 2 Feb 2007 17:18:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>,
       Nigel Kirkland <nigel.kirkland@qlogic.com>
Subject: Re: [BUG] Unable to handle kernel NULL pointer
 dereference...as_move_to_dispatch+0x11/0x135
Message-Id: <20070202171810.5f089b38.randy.dunlap@oracle.com>
In-Reply-To: <20070202162541.20e1e930.akpm@linux-foundation.org>
References: <20070122183510.GA19905@andrew-vasquezs-computer.local>
	<20070201232302.905962b6.akpm@linux-foundation.org>
	<20070202205630.GI3737@andrew-vasquezs-computer.local>
	<20070202162541.20e1e930.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007 16:25:41 -0800 Andrew Morton wrote:

> On Fri, 2 Feb 2007 12:56:30 -0800
> Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:
> 
> > > >         dt of=/dev/raw/raw1 procs=8 oncerr=abort bs=16k disable=stats limit=2m passes=1000000 pattern=iot dlimit=2048
> 
> What is this mysterious dt command, btw?

I expect that it's the one here:
http://www.scsifaq.org/RMiller_Tools/index.html

---
~Randy
