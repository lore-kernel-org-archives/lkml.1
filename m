Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbXGJIMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbXGJIMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbXGJIL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:11:59 -0400
Received: from ozlabs.org ([203.10.76.45]:49381 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbXGJIL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:11:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18067.15564.241168.217875@cargo.ozlabs.ibm.com>
Date: Tue, 10 Jul 2007 18:01:16 +1000
From: Paul Mackerras <paulus@samba.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [patch 0/6] PS3 Storage Drivers for 2.6.23, take 4
In-Reply-To: <20070710075506.GS13902@kernel.dk>
References: <20070704132212.726923000@pademelon.sonytel.be>
	<Pine.LNX.4.62.0707100944470.22782@pademelon.sonytel.be>
	<20070710075506.GS13902@kernel.dk>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe writes:

> I have no objections to the block bits, however I feel uneasy merging
> the full patchset unless patch #1 has been acked by the platform person.

I have the first 3 patches in my queue, so yes I've acked it.  It's
probably easiest if the remaining 3 go through my queue once they've
been acked - or if you prefer, you can push #4 via your tree once I've
got Linus to pull my tree.  Let me know either way.

Paul.
