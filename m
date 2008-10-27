Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbYJ0EzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbYJ0EzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 00:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYJ0EzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 00:55:01 -0400
Received: from sh.osrg.net ([192.16.179.4]:36403 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbYJ0EzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 00:55:01 -0400
Date: Mon, 27 Oct 2008 13:54:42 +0900
To: Mike.Miller@hp.com
Cc: fujita.tomonori@lab.ntt.co.jp, Tom.Lawler@hp.com,
       James.Bottomley@HansenPartnership.com, Jens.Axboe@oracle.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: RE: [RFC PATCH] HP (Compaq) Smart Array 5xxx controller SCSI driver
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A77884C01B0C584@GVW0547EXC.americas.hpqcorp.net>
References: <20080719195150Y.fujita.tomonori@lab.ntt.co.jp>
	<0F5B06BAB751E047AB5C87D1F77A77884C01B0C584@GVW0547EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081027135322Y.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008 15:10:57 +0000
"Miller, Mike (OS Dev)" <Mike.Miller@hp.com> wrote:

> Tomo wrote:
> 
> >
> > My scsi driver is still in an early stage (I tried to keep
> > the changes minimum). I can detect logical units, mount a
> > file system, do lots of I/Os, however, there are lots of
> > TODOs in the management features.
> >
> > If I can get an ACK from HP about the long-term migration of
> > cciss to SCSI, I'm happy to keep working on the SCSI cciss
> > driver and maintain it until HP takes over the driver.
> 
> Just a brief update. HP has developed a scsi version of cciss. It was originally done for another environment but we have decided to use it as the base for Linux. It was authored by Tom Lawler of HP. We are currently in the process of getting the Open Source Review Board approval to release the code to the community.
> 
> It's unclear right now as to who will be the maintainer.

Awesome, I'm really looking forward to the release.

Thanks!
