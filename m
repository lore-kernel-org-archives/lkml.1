Return-Path: <linux-kernel-owner+w=401wt.eu-S932508Ab0AFRpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab0AFRpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932469Ab0AFRpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:45:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295Ab0AFRpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:45:49 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100106172112.GA17163@lst.de>
References: <20100106172112.GA17163@lst.de>
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux@arm.linux.org.uk, ysato@users.sourceforge.jp, tony.luck@intel.com,
       geert@linux-m68k.org, zippel@linux-m68k.org, gerg@uclinux.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jdike@addtoit.com,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/3] generic sys_old_select
Date: Wed, 06 Jan 2010 17:44:29 +0000
Message-ID: <31914.1262799869@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> Add a generic implementation of the old select syscall, which expects it's
> argument in a memory block and switch all architectures over to use it.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: David Howells <dhowells@redhat.com> [for MN10300]
