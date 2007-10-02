Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbXJBKoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbXJBKoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 06:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbXJBKo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 06:44:28 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59064 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbXJBKo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 06:44:27 -0400
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, greg@kroah.com
In-Reply-To: <3ae72650710020331o2ce5bd20wccc1964855279796@mail.gmail.com>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <1191313025.13204.30.camel@twins>
	 <20071002013148.18958af2.akpm@linux-foundation.org>
	 <1191314911.13204.41.camel@twins>
	 <3ae72650710020331o2ce5bd20wccc1964855279796@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 12:44:21 +0200
Message-Id: <1191321861.13204.53.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 12:31 +0200, Kay Sievers wrote:

> What would be the point in another top-level tree for device
> information? All devices you are exporting information for, are
> already in the sysfs tree, right?

Never did find NFS mounts/servers/superblocks or whatever constitutes a
BDI for NFS in there. Same goes for all other networked filesystems for
that matter.



