Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbYITRnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbYITRnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 13:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbYITRnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 13:43:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbYITRnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 13:43:07 -0400
Date: Sat, 20 Sep 2008 10:42:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com, steffen.klassert@secunet.com
Subject: Re: [PATCH 2/2]: softirq: Add support for triggering softirq work
 on softirqs.
Message-Id: <20080920104249.c079b6d2.akpm@linux-foundation.org>
In-Reply-To: <20080920.035602.226564809.davem@davemloft.net>
References: <20080919.234832.127229997.davem@davemloft.net>
	<20080920004608.a3123052.akpm@linux-foundation.org>
	<20080920.035602.226564809.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2008 03:56:02 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> I've got your kerneldoc right here buddy boy...

thanks.  It's surprising how much that improves the code review.

> +/***

/** is sufficient & conventional for kerneldoc.

