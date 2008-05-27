Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYE0MxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYE0MxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 08:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYE0MxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 08:53:04 -0400
Received: from brick.kernel.dk ([87.55.233.238]:20144 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbYE0MxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 08:53:02 -0400
Date: Tue, 27 May 2008 14:52:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-btrace@vger.kernel.org
Subject: Re: [PATCH 1/2] Added in MESSAGE notes for blktraces
Message-ID: <20080527125259.GQ7712@kernel.dk>
References: <483C0216.70008@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483C0216.70008@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27 2008, Alan D. Brunelle wrote:
> 
> Allows messages to be inserted into blktrace streams.
> 
> Associated blkparse patches will be posted to linux-btrace & may also be
> found at:
> 
> http://free.linux.hp.com/~adb/blktrace/0001-Added-in-handling-of-MESSAGE-notes.patch
> http://free.linux.hp.com/~adb/blktrace/0002-Added-in-new-message-updates-to-the-documentation.patch

This now looks great! I applied both patches, note that your mailer
still has wrapping problems (the patches were both line wrapped).

-- 
Jens Axboe

