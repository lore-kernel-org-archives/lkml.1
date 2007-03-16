Return-Path: <linux-kernel-owner+w=401wt.eu-S1752448AbXCPCva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbXCPCva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 22:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXCPCva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 22:51:30 -0400
Received: from xenotime.net ([66.160.160.81]:32961 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752448AbXCPCv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 22:51:29 -0400
Date: Thu, 15 Mar 2007 18:49:54 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Artem Bityutskiy <dedekind@infradead.org>, linux-kernel@vger.kernel.org,
       haver@vnet.ibm.com, hch@infradead.org, dwmw2@infradead.org
Subject: Re: [PATCH 10/22 take 3] UBI: EBA unit
Message-Id: <20070315184954.d3e44243.rdunlap@xenotime.net>
In-Reply-To: <20070315232951.GA29295@crusty.rchland.ibm.com>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
	<20070314152024.1112.15655.sendpatchset@localhost.localdomain>
	<20070315110703.1c2dcce4.akpm@linux-foundation.org>
	<20070315142410.371adbf0.rdunlap@xenotime.net>
	<20070315232951.GA29295@crusty.rchland.ibm.com>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007 18:29:51 -0500 Josh Boyer wrote:

> On Thu, Mar 15, 2007 at 02:24:10PM -0700, Randy Dunlap wrote:
> > On Thu, 15 Mar 2007 11:07:03 -0800 Andrew Morton wrote:
> > 
> > > 
> > > There's way too much code here to expect it to get decently reviewed, alas.
> > 
> > Yes.
> > 
> > /me repeats wish that Not Everything Should Be Sent to lkml.  :(
> 
> Just curious, but where would you suggest this be sent to for review then?

Valid question.  I should have chosen some other more appropriate
patch to make that comment.

I don't see a better list for UBI patches, so lkml is OK IMO.


Here is a summary of my thinking on Linux-related mailing lists.

1.  Bug reports can go to lkml or focused mailing lists.

2.  Development (like patches) should go to focused mailing lists
if there is such a list and they have enough usage.

Development areas that qualify for this IMO are:
- ACPI
- ATA
- file systems
- frame buffer
- ieee1394
- MM/VM
- multimedia
- networking
- PCI
- power management, suspend/resume
- SCSI
- sound
- USB
- virtualization


(not that I expect anything close to concensus on this)
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
