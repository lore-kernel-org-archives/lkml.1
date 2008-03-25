Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbYCYEU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbYCYEU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 00:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYCYEUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 00:20:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbYCYEUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 00:20:44 -0400
Date: Mon, 24 Mar 2008 21:19:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>,
       Tejun Heo <htejun@gmail.com>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Message-Id: <20080324211925.dcd25237.akpm@linux-foundation.org>
In-Reply-To: <47E87942.2020409@rtr.ca>
References: <47E875AD.1000901@rtr.ca>
	<47E87942.2020409@rtr.ca>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008 00:02:10 -0400 Mark Lord <lkml@rtr.ca> wrote:

> Is it time now for HDIO_GETGEO64 to make an appearance?
> Similar to how the existing BLKGETSIZE64 is supplanting BLKGETSIZE ?

That sounds useful.

But you're the one who has investigated this - please make a recommendation?
