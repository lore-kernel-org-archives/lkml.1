Return-Path: <linux-kernel-owner+w=401wt.eu-S965458AbXBRBJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965458AbXBRBJX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 20:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965514AbXBRBJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 20:09:23 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53379 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965458AbXBRBJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 20:09:22 -0500
Date: Sat, 17 Feb 2007 17:09:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: mm snapshot broken-out-2007-02-17-03-25.tar.gz uploaded
Message-Id: <20070217170917.1e9a03cd.akpm@linux-foundation.org>
In-Reply-To: <45D7A37C.3060306@googlemail.com>
References: <200702171127.l1HBRnhe025635@shell0.pdx.osdl.net>
	<45D74B37.1040507@googlemail.com>
	<20070217114601.19544615.akpm@linux-foundation.org>
	<6bffcb0e0702171158o5f384e60sacae4e45563d7321@mail.gmail.com>
	<20070217120402.ec517938.akpm@linux-foundation.org>
	<6bffcb0e0702171423y3440f8d3n1caa31904ee2eee9@mail.gmail.com>
	<20070217151210.f962716f.akpm@linux-foundation.org>
	<45D7A37C.3060306@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Feb 2007 01:53:16 +0100 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> > I wonder why.  I can't make it happen on two machines, scsi, sata and IDE. 
> > And afaict git-block isn't changed from 2.6.20-mm1.
> > 
> > Are you sure?
> > 
> 
> Absolutely? No.
> 
> Do you believe in statistic?

devoutly.

We don't have much to go on, alas.  Could you please provide the .config
and a description of your setup?  What sort of disk controller, what sort
of disks, which IO scheduler, etc?

