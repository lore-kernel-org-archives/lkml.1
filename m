Return-Path: <linux-kernel-owner+w=401wt.eu-S1759871AbZCRSNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871AbZCRSNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759650AbZCRSNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:13:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:51098 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759685AbZCRSNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 14:13:18 -0400
Subject: Re: [tip:tracing/ftrace] tracing: fix oops in
 tracepoint_update_probe_range()
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinderrajput@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20090318180007.GE5981@nowhere>
References: <1237394936.3132.1.camel@localhost.localdomain>
	 <tip-966a6fdf6210e3ac8ce00b61cd1107cdf97ce744@git.kernel.org>
	 <1237398997.22438.10.camel@ht.satnam>  <20090318180007.GE5981@nowhere>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 23:42:10 +0530
Message-Id: <1237399930.22438.16.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 19:00 +0100, Frederic Weisbecker wrote:

> Jaswinder, It's hard for me to reproduce it via your config.
> May be it's because I had to update it to match latest -tip tree and
> then I inserted some noise inside.
> 
> Could you please send me your bad vmlinux, so that I can have a first look at
> your elf sections and see if there is something helpful inside.
> 

OK I am uploading vmlinux (file size 14729799) and dmesg on :

http://userweb.kernel.org/~jaswinder/oops_20090318/

Are you testing on 32 bit or 64 bit machine.

I am getting this error on 64 bit AMD box.

Thanks
--
JSR

