Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbZJ0PPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbZJ0PPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 11:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbZJ0PPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 11:15:50 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:40832 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbZJ0PPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 11:15:49 -0400
Date: Tue, 27 Oct 2009 09:15:52 -0600
From: Alex Chiang <achiang@hp.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: pci-express hotplug
Message-ID: <20091027151552.GB15737@ldl.fc.hp.com>
References: <20091012150603.GK9228@kernel.dk> <20091012214854.GA14102@ldl.fc.hp.com> <20091013082903.GQ9228@kernel.dk> <20091013172731.GB22797@ldl.fc.hp.com> <20091014081309.GM9228@kernel.dk> <20091020190707.GA25615@ldl.fc.hp.com> <20091026105419.GA10727@kernel.dk> <20091027024841.GA30509@ldl.fc.hp.com> <20091027082635.GS10727@kernel.dk> <20091027083419.GU10727@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027083419.GU10727@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe <jens.axboe@oracle.com>:
> 
> Since this is a new board and BIOS, below is the info from loading
> acpiphp with debug enabled and acpi debug enabled.

Thanks. Can you please send your DSDT as well please?

You can obtain that with the acpidump tools. If they're not part
of your distro, you can find them on lesswatts.org.

Thanks.

/ac

