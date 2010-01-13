Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182Ab0AMJXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab0AMJXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088Ab0AMJXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:23:07 -0500
Received: from ozlabs.org ([203.10.76.45]:34787 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab0AMJXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:23:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Wrong cpumask_of_node usage in kernel/smp.c
Date: Wed, 13 Jan 2010 19:52:59 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-17-generic; KDE/4.3.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <20100113001401.GA26192@linux-os.sc.intel.com>
In-Reply-To: <20100113001401.GA26192@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001131953.00177.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jan 2010 10:44:01 am Pallipadi, Venkatesh wrote:
> 
> I am getting dump_stack from cpumask_of_node() with recent kernels.
> Dump stack msg that repeats few times
> [    6.504569] cpumask_of_node(2): node > nr_node_ids(1)

Thanks, this fix is already queued.

Cheers,
Rusty.
