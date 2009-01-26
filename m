Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbZAZW6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbZAZW6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZAZW55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:57:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbZAZW54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:57:56 -0500
Date: Mon, 26 Jan 2009 14:57:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: cache flush timeouts by blk_queue_ordered()
Message-Id: <20090126145716.cf7767aa.akpm@linux-foundation.org>
In-Reply-To: <20090126223942.GA12463@lanczos.q-leap.de>
References: <20081120181919.GA3818@lanczos.q-leap.de>
	<20090126115540.694ea262.akpm@linux-foundation.org>
	<20090126223942.GA12463@lanczos.q-leap.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 23:39:42 +0100
Bernd Schubert <bs@q-leap.de> wrote:

> Andrew, thanks a lot! I'm really always impressed how you manage to find time
> to grep through all the threads, even those nobody cared to look at for months.
> 

Only a very small subset, alas.


> I posted a patch, but never got a comment on it.
> 
> https://kerneltrap.org/mailarchive/linux-scsi/2008/11/26/4242484

Three weeks ago: it's been forgotten about.

I suggest that you redo the patch series and resend the uncontroversial
bits.  Feel free to copy me on them and I'll put them into my
auto-resend queue.  That eventually causes something to happen.


