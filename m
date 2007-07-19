Return-Path: <linux-kernel-owner+w=401wt.eu-S936595AbXGSBF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936595AbXGSBF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 21:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760778AbXGSBFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 21:05:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60381 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759408AbXGSBFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 21:05:19 -0400
Date: Wed, 18 Jul 2007 18:04:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATH 0/1] Kexec jump - v2 - the first step to kexec based
 hibernation
Message-Id: <20070718180420.02352d4f.akpm@linux-foundation.org>
In-Reply-To: <1184483593.1898.98.camel@caritas-dev.intel.com>
References: <1184483593.1898.98.camel@caritas-dev.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2007 15:13:13 +0800
"Huang, Ying" <ying.huang@intel.com> wrote:

> 
> The changelog between v1 and v2
> 
> 1. The kexec jump implementation is put into the kexec/kdump
>    framework instead of software suspend framework. The device
>    and CPU state save/restore code of software suspend is called
>    when needed.
> 
> 2. The same code path is used for both kexec a new kernel and jump
>    back to original kernel.

I like the idea but I think I'll let people chat about it a bit more
before looking at merging the patches, OK?
