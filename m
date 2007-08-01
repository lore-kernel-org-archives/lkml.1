Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbXHAX5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbXHAX5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 19:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbXHAX5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 19:57:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38653 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586AbXHAX5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 19:57:42 -0400
Date: Wed, 1 Aug 2007 16:57:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Renninger <trenn@suse.de>
Subject: Re: cpufreq.c:(.text+0xaf178): undefined reference to
 `cpufreq_gov_performance'
Message-Id: <20070801165704.a26961b7.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0708011631k7f476af2jcd01d2875f4b4b17@mail.gmail.com>
References: <a44ae5cd0708011631k7f476af2jcd01d2875f4b4b17@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007 16:31:46 -0700
"Miles Lane" <miles.lane@gmail.com> wrote:

>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `__cpufreq_governor':
> cpufreq.c:(.text+0xaf178): undefined reference to `cpufreq_gov_performance'
> cpufreq.c:(.text+0xaf18a): undefined reference to `cpufreq_gov_performance'
> make: *** [.tmp_vmlinux1] Error 1

One for Thomas, I expect.

> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.23-rc1-mm2
> # Wed Aug  1 15:46:12 2007

<useful thanks.  But snipped>
