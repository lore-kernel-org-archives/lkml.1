Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab0BBXoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 18:44:19 -0500
Received: from tservice.net.ru ([195.178.208.66]:41762 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab0BBXoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 18:44:18 -0500
Date: Wed, 3 Feb 2010 02:44:17 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>, GregKH <greg@kroah.com>
Subject: Re: [Bug #14894] pohmelfs: NULL pointer dereference
Message-ID: <20100202234417.GA705@ioremap.net>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <20091230091433.GU4489@kernel.dk> <20100202205743.GA26703@ioremap.net> <201002022221.09895.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002022221.09895.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 10:21:09PM +0100, Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > Jens provided a patch below, which I tested to fix the problem.
> 
> Thanks, I've linked the Jens' patch to the bugzilla entry and marked the
> bug as resolved.

Thank you, I pushed a patch to Greg with Jens sign.

-- 
	Evgeniy Polyakov
