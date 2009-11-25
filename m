Return-Path: <linux-kernel-owner+w=401wt.eu-S934133AbZKYIiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934133AbZKYIiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZKYIiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:38:21 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:38480 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbZKYIiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:38:19 -0500
Date: Wed, 25 Nov 2009 09:38:23 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       sparclinux <sparclinux@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       NFS list <linux-nfs@vger.kernel.org>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/5] s390: remove unused nfsd #includes
Message-ID: <20091125093823.7b079905@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <4B0C1F98.4000204@panasas.com>
References: <4B0C1EB7.50508@panasas.com>
	<4B0C1F98.4000204@panasas.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 20:02:00 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> Some unused includes removed.
> 
> This patch is in an effort to cleanup nfsd headers and move
> private definitions to source directory.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  arch/s390/kernel/compat_linux.c |    6 ------
>  arch/s390/kernel/compat_linux.h |    4 ----
>  2 files changed, 0 insertions(+), 10 deletions(-)
 
The patch is fine. I'll add it to the feature branch of git390 for the
next merge window. 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

