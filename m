Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab0BHKxN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:53:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab0BHKxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:53:11 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100202185755.GA3630@lst.de>
References: <20100202185755.GA3630@lst.de>
To: Christoph Hellwig <hch@lst.de>
Cc: dhowells@redhat.com, roland@redhat.com, oleg@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, mattst88@gmail.com,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, vapier@gentoo.org, starvik@axis.com,
       jesper.nilsson@axis.com, ysato@users.sourceforge.jp,
       takata@linux-m32r.org, gerg@uclinux.org, monstr@monstr.eu,
       ralf@linux-mips.org, jdike@addtoit.com, chris@zankel.net
Subject: Re: [PATCH 1/14] move user_enable_single_step & co prototypes to linux/ptrace.h
Date: Mon, 08 Feb 2010 10:50:41 +0000
Message-ID: <22619.1265626241@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> While in theory user_enable_single_step/user_disable_single_step/
> user_enable_blockstep could also be provided as an inline or macro there's no
> good reason to do so, and having the prototype in one places keeps code size
> and confusion down.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: David Howells <dhowells@redhat.com>
