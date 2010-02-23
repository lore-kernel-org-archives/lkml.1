Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab0BWHjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 02:39:07 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53305 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab0BWHjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 02:39:06 -0500
Date: Tue, 23 Feb 2010 08:39:02 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: dann frazier <dannf@hp.com>
Cc: akpm@linux-foundation.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com,
       brace@beardog.cce.hp.com, scameron@beardog.cce.hp.com,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] cciss: export linux/cciss_defs.h header
Message-ID: <20100223073901.GK1025@kernel.dk>
References: <20100223132619.e6f5ff0e.sfr@canb.auug.org.au> <20100223045221.GG3923@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100223045221.GG3923@ldl.fc.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22 2010, dann frazier wrote:
> 'make headers_check' began to fail after cciss_defs.h was introduced in:
>    429c42c9d246f5bda868495c09974312a0177328
> 
> usr/include/linux/cciss_ioctl.h:6: included file 'linux/cciss_defs.h' is not exported

Thanks Dann for the patch, and sorry Stephen for the breakage.

-- 
Jens Axboe

