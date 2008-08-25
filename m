Return-Path: <linux-kernel-owner+w=401wt.eu-S1755039AbYHYFwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039AbYHYFwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 01:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYHYFwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 01:52:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34660 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbYHYFwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 01:52:35 -0400
Subject: Re: Quad core CPUs loaded at only 50% when running a CPU and mmap
	intensive multi-threaded task
From: Peter Zijlstra <peterz@infradead.org>
To: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, rml@tech9.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner mingo@redhat.com" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <48B1CC15.2040006@gmail.com>
References: <48B1CC15.2040006@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 25 Aug 2008 07:51:16 +0200
Message-Id: <1219643476.20732.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-25 at 00:01 +0300, Török Edwin wrote:
> Hi Ingo,
> 
> When I run clamd (www.clamav.net), I can only get to load my CPU 50% 
> (according to top), and disks at 30% (according to iostat -x 3), 
> regardless how many threads I set (I tried 4, 8, 16, 32).


Can you share your .config, and prehaps tell what kernel version did
work for you?

