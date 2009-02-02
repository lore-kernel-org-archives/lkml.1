Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbZBBJEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbZBBJEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 04:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZBBJEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 04:04:23 -0500
Received: from ozlabs.org ([203.10.76.45]:46745 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZBBJEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 04:04:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: #tj-percpu has been rebased
Date: Mon, 2 Feb 2009 19:34:13 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, cpw@sgi.com
References: <49833350.1020809@kernel.org> <4983E5D3.3040100@kernel.org>
In-Reply-To: <4983E5D3.3040100@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200902021934.14168.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 January 2009 16:16:59 Tejun Heo wrote:
> Anyways, please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

Thanks.  cpualloc patches rebased on top of it (I had to include the module
patch I've got queued for 2.6.29, otherwise gratuitous conflicts):

	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/tj-percpu-cpualloc master

Boot tested here, but that's no guarantee that something didn't break.

I'm going to be occupied with finishing off cpumask_t this cycle, so I'd be
happy for you to take ownership of any and all of these that you want to keep.
I'll try to keep up with other patches as you post them.

Thanks!
Rusty.
