Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbZAEJPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbZAEJPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZAEJPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:15:00 -0500
Received: from brick.kernel.dk ([93.163.65.50]:21186 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbZAEJPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:15:00 -0500
Date: Mon, 5 Jan 2009 10:13:56 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0 of 3] Block Layer Data Integrity Fixes
Message-ID: <20090105091356.GE32491@kernel.dk>
References: <patchbomb.1231055017@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1231055017@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04 2009, Martin K. Petersen wrote:
> 
> Block integrity updates for 2.6.29.
> 
> 3 files changed, 29 insertions(+), 23 deletions(-)
> block/blk-integrity.c |   25 ++++++++++++++-----------
> fs/bio-integrity.c    |   26 +++++++++++++++-----------
> include/linux/bio.h   |    1 -

Applied 1-3 for 2.6.29

-- 
Jens Axboe

