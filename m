Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab0BHOIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 09:08:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab0BHOIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 09:08:21 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100201185506.GA11045@lst.de>
References: <20100201185506.GA11045@lst.de>
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux@arm.linux.org.uk, ysato@users.sourceforge.jp, tony.luck@intel.com,
       geert@linux-m68k.org, zippel@linux-m68k.org, gerg@uclinux.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jdike@addtoit.com,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/6] generic sys_old_select
Date: Mon, 08 Feb 2010 14:05:33 +0000
Message-ID: <25715.1265637933@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> Add a generic implementation of the old select syscall, which expects it's
> argument in a memory block and switch all architectures over to use it.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: David Howells <dhowells@redhat.com> [MN10300]
