Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZJ1JSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZJ1JSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 05:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbZJ1JSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 05:18:15 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59065 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbZJ1JSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 05:18:14 -0400
Date: Wed, 28 Oct 2009 10:18:18 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alex Chiang <achiang@hp.com>
Cc: Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091028091818.GZ10727@kernel.dk>
References: <20091012214854.GA14102@ldl.fc.hp.com> <20091013082903.GQ9228@kernel.dk> <20091013172731.GB22797@ldl.fc.hp.com> <20091014081309.GM9228@kernel.dk> <20091020190707.GA25615@ldl.fc.hp.com> <20091026105419.GA10727@kernel.dk> <20091027024841.GA30509@ldl.fc.hp.com> <20091027082635.GS10727@kernel.dk> <20091027083419.GU10727@kernel.dk> <20091027151552.GB15737@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027151552.GB15737@ldl.fc.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27 2009, Alex Chiang wrote:
> * Jens Axboe <jens.axboe@oracle.com>:
> > 
> > Since this is a new board and BIOS, below is the info from loading
> > acpiphp with debug enabled and acpi debug enabled.
> 
> Thanks. Can you please send your DSDT as well please?
> 
> You can obtain that with the acpidump tools. If they're not part
> of your distro, you can find them on lesswatts.org.

Sent privately.

-- 
Jens Axboe

