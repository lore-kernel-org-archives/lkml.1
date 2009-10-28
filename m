Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbZJ1TzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbZJ1TzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 15:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbZJ1TzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 15:55:19 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:14085 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbZJ1TzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 15:55:18 -0400
Date: Wed, 28 Oct 2009 13:55:21 -0600
From: Alex Chiang <achiang@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091028195521.GA8749@ldl.fc.hp.com>
References: <20091013082903.GQ9228@kernel.dk> <20091013172731.GB22797@ldl.fc.hp.com> <20091014081309.GM9228@kernel.dk> <20091020190707.GA25615@ldl.fc.hp.com> <20091026105419.GA10727@kernel.dk> <20091027024841.GA30509@ldl.fc.hp.com> <20091027082635.GS10727@kernel.dk> <20091027083419.GU10727@kernel.dk> <20091027151552.GB15737@ldl.fc.hp.com> <20091028091818.GZ10727@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028091818.GZ10727@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe <jens.axboe@oracle.com>:
> On Tue, Oct 27 2009, Alex Chiang wrote:
> > * Jens Axboe <jens.axboe@oracle.com>:
> > > 
> > > Since this is a new board and BIOS, below is the info from loading
> > > acpiphp with debug enabled and acpi debug enabled.
> > 
> > Thanks. Can you please send your DSDT as well please?
> > 
> > You can obtain that with the acpidump tools. If they're not part
> > of your distro, you can find them on lesswatts.org.
> 
> Sent privately.

Sorry, one more RTT of debug info needed. :-/

Can you send dmesg output and contents of /proc/iomem?

Thanks.

