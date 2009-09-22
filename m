Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZIVG1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZIVG1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 02:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbZIVG1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 02:27:38 -0400
Received: from ozlabs.org ([203.10.76.45]:44922 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172AbZIVG1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 02:27:37 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] virtio-blk: set QUEUE_ORDERED_DRAIN by default
Date: Tue, 22 Sep 2009 15:57:38 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: borntraeger@de.ibm.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20090820205616.GA5503@lst.de> <20090917173142.GA1518@lst.de>
In-Reply-To: <20090917173142.GA1518@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909221557.39272.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 03:01:42 am Christoph Hellwig wrote:
> Err, I'll take this one back for now pending some more discussion.
> What we need more urgently is the writeback cache flag, which is now
> implemented in qemu, patch following ASAP.

OK, still catching up on mail.  I'll push them out of the queue for now.

Thanks,
Rusty.
