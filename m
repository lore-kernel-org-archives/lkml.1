Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYHDJ4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYHDJ4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 05:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYHDJ4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 05:56:36 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26068 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbYHDJ4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 05:56:35 -0400
Date: Mon, 4 Aug 2008 11:56:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mike Miller <mike.miller@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 6/6] cciss: fix bug if scsi tape support is disabled
Message-ID: <20080804095633.GA20055@kernel.dk>
References: <20080730211842.GF1758@roadking.ldev.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730211842.GF1758@roadking.ldev.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30 2008, Mike Miller wrote:
> Patch 6 of 6
> 
> Bug fix. If SCSI tape support is turned off we get an implicit declaration
> of cciss_unregister_scsi error in cciss_remove_one.
> Please consider this for inclusion.

Applied 1-6, thanks.

-- 
Jens Axboe

