Return-Path: <linux-kernel-owner+w=401wt.eu-S935171AbZLGOMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935171AbZLGOMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935132AbZLGOMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:12:38 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:63797 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935122AbZLGOMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:12:38 -0500
Date: Mon, 7 Dec 2009 09:12:29 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Emese Revfy <re.emese@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/31] Constify struct extent_io_ops for 2.6.32 v1
Message-ID: <20091207141229.GB1710@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Emese Revfy <re.emese@gmail.com>, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <4B198670.2000406@gmail.com>
 <4B198B4C.3030201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B198B4C.3030201@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B1D0D50.00DF:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 11:21:00PM +0100, Emese Revfy wrote:
> From: Emese Revfy <re.emese@gmail.com>
> 
> Constify struct extent_io_ops.
> 
> Signed-off-by: Emese Revfy <re.emese@gmail.com>
> ---
>  fs/btrfs/disk-io.c   |    4 ++--
>  fs/btrfs/extent_io.h |   30 +++++++++++++++---------------
>  fs/btrfs/inode.c     |    4 ++--
>  3 files changed, 19 insertions(+), 19 deletions(-)
> 

Thanks, I'll pick this up in the btrfs tree unless Linus has already
grabbed it.

-chris
