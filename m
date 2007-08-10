Return-Path: <linux-kernel-owner+w=401wt.eu-S938640AbXHJQjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938640AbXHJQjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933450AbXHJQiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:38:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42478 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933475AbXHJQiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:38:54 -0400
Date: Fri, 10 Aug 2007 09:38:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2
Message-Id: <20070810093817.a9bec74f.akpm@linux-foundation.org>
In-Reply-To: <46BC5B75.80102@googlemail.com>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<46BC3CB1.2090503@googlemail.com>
	<46BC5B75.80102@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 14:35:01 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:

> In file included from include/linux/blkdev.h:17,
>                  from kernel/sched.c:45:
> include/linux/bsg.h:67: warning: 'struct request_queue' declared inside parameter list
> include/linux/bsg.h:67: warning: its scope is only this definition or declaration, which is probably not what you want
> include/linux/bsg.h:71: warning: 'struct request_queue' declared inside parameter list

Thanks, I'll fix that up.
