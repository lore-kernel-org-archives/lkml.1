Return-Path: <linux-kernel-owner+w=401wt.eu-S933612AbYA3UUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbYA3UUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765641AbYA3UPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:15:05 -0500
Received: from brick.kernel.dk ([87.55.233.238]:9050 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765719AbYA3UPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:15:03 -0500
Date: Wed, 30 Jan 2008 21:14:59 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] unexport add_disk_randomness
Message-ID: <20080130201458.GY15220@kernel.dk>
References: <20080130200227.GS29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130200227.GS29368@does.not.exist>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30 2008, Adrian Bunk wrote:
> This patch removes the no longer used EXPORT_SYMBOL(add_disk_randomness).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks, applied.

-- 
Jens Axboe

