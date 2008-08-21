Return-Path: <linux-kernel-owner+w=401wt.eu-S1760894AbYHUT0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894AbYHUT0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 15:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180AbYHUT0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 15:26:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:47783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbYHUT0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 15:26:08 -0400
Date: Thu, 21 Aug 2008 12:23:15 -0700
From: Greg KH <gregkh@suse.de>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] linux-next: Tree for August 21 - WARNING: at
	fs/sysfs/dir.c:465 sysfs_add_one()
Message-ID: <20080821192315.GA17600@suse.de>
References: <20080821191253.ba180d5e.sfr@canb.auug.org.au> <48ADC08C.6030406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ADC08C.6030406@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 12:52:52AM +0530, Kamalesh Babulal wrote:
> Hi,
> 
> while booting up the next-20080821 kernel on x86 machine, warning shows up for sysfs_add_one
> of acpi getting called twice

See lkml, patches to resolve this have been posted.

thanks,

greg k-h
