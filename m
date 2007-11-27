Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbXK0TNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbXK0TNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 14:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757900AbXK0TN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 14:13:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:3539 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbXK0TN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 14:13:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,220,1194249600"; 
   d="scan'208";a="236054806"
Date: Tue, 27 Nov 2007 11:11:36 -0800
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Alex Chiang <achiang@hp.com>, Gary Hade <garyhade@us.ibm.com>,
       Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de, lenb@kernel.org,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4, v3] Physical PCI slot objects
Message-ID: <20071127111136.77cb61fc@appleyard>
In-Reply-To: <20071127030454.GC23277@us.ibm.com>
References: <20071117182954.GA25003@ldl.fc.hp.com>
	<20071119233225.GA6931@us.ibm.com>
	<20071126222253.GA31708@ldl.fc.hp.com>
	<20071127030454.GC23277@us.ibm.com>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 19:04:54 -0800
Gary Hade <garyhade@us.ibm.com> wrote:

> > Is this patchset appropriate for the -mm tree yet?  
> 
> I would defer to our illustrious maintainers on this one. :)
> 
> > Or do you think it still needs more work?  
> 
> I am now much more comfortable with your changes with respect
> to acpiphp on the systems I worry about but others may have
> concerns with respect to the other hotplug drivers, or even
> acpiphp, on other systems.

I'm ok with adding it to my quilt tree (and into -mm) after Gary gets
back to us later this week.
