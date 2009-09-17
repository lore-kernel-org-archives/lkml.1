Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbZIQRbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbZIQRbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758241AbZIQRbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:31:48 -0400
Received: from verein.lst.de ([213.95.11.210]:43115 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757351AbZIQRbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:31:45 -0400
Date: Thu, 17 Sep 2009 19:31:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: borntraeger@de.ibm.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: set QUEUE_ORDERED_DRAIN by default
Message-ID: <20090917173142.GA1518@lst.de>
References: <20090820205616.GA5503@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820205616.GA5503@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Err, I'll take this one back for now pending some more discussion.
What we need more urgently is the writeback cache flag, which is now
implemented in qemu, patch following ASAP.

