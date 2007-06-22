Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbXFVHO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbXFVHO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 03:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbXFVHOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 03:14:21 -0400
Received: from www.osadl.org ([213.239.205.134]:46275 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751806AbXFVHOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 03:14:20 -0400
Subject: Re: [PATCH -rt] irq nobody cared workaround for i386
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <467A61A3.7060804@redhat.com>
References: <4676CF81.2000205@redhat.com> <4677D7AF.7040700@redhat.com>
	 <467932B4.6030800@redhat.com> <467936FE.8050704@redhat.com>
	 <467A61A3.7060804@redhat.com>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 09:14:16 +0200
Message-Id: <1182496456.20203.35.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 13:31 +0200, Michal Schmidt wrote:
> OK, I fixed the spacing in both occurences.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> 
> --- arch/i386/kernel/io_apic.c.orig	2007-06-19 08:40:05.000000000 -0400
> +++ arch/i386/kernel/io_apic.c	2007-06-21 06:51:16.000000000 -0400

Please create -p1 patches next time.

Applied. Thanks,

	tglx


