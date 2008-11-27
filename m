Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYK0Mz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYK0Mz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYK0Mzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:55:49 -0500
Received: from ozlabs.org ([203.10.76.45]:42386 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbYK0Mzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:55:48 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] virtio_blk: fix type warning
Date: Thu, 27 Nov 2008 23:25:43 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, jens.axboe@oracle.com,
       akpm <akpm@linux-foundation.org>
References: <20081126131550.69eea284.randy.dunlap@oracle.com>
In-Reply-To: <20081126131550.69eea284.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811272325.43802.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2008 07:45:50 Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix parameter type warning:
>
> linux-next-20081126/drivers/block/virtio_blk.c:307: warning: large integer
> implicitly truncated to unsigned type

Thanks, applied.

Rusty.
