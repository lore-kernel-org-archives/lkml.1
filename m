Return-Path: <linux-kernel-owner+w=401wt.eu-S1758032AbZFWDvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbZFWDvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 23:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZFWDvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 23:51:11 -0400
Received: from ozlabs.org ([203.10.76.45]:60625 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381AbZFWDvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 23:51:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] trivial, update the comment in kthread_stop()
Date: Tue, 23 Jun 2009 13:21:10 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20090619005113.GA12208@redhat.com>
In-Reply-To: <20090619005113.GA12208@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906231321.11313.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009 10:21:13 am Oleg Nesterov wrote:
> "kthreads: rework kthread_stop()"
> commit 63706172f332fd3f6e7458ebfb35fa6de9c21dc5 removed the limitation,
> but forgot to update the comment.
>
> Since that commit it is OK to use kthread_stop() even if kthread can exit
> itself.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Thanks, I've dropped this in my queue with other misc bits, but I really 
consider you to own kthread these days.

Thanks!
Rusty.
