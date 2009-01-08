Return-Path: <linux-kernel-owner+w=401wt.eu-S1762798AbZAHUP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762798AbZAHUP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762689AbZAHUPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:15:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35021 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762640AbZAHUPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:15:05 -0500
Date: Thu, 8 Jan 2009 18:14:32 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for January 8 (multimedia/cx88)
Message-ID: <20090108181432.3ab1ea9d@pedra.chehab.org>
In-Reply-To: <49663B74.6010707@oracle.com>
References: <20090108171730.19a41e14.sfr@canb.auug.org.au>
	<49663B74.6010707@oracle.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jan 2009 09:44:20 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> 
> linux-next-20090108/drivers/media/video/cx88/cx88-i2c.c: In function 'cx88_call_i2c_clients':
> linux-next-20090108/drivers/media/video/cx88/cx88-i2c.c:122: error: 'struct cx88_core' has no member named 'gate_ctrl'
> linux-next-20090108/drivers/media/video/cx88/cx88-i2c.c:123: error: 'struct cx88_core' has no member named 'gate_ctrl'
> linux-next-20090108/drivers/media/video/cx88/cx88-i2c.c:127: error: 'struct cx88_core' has no member named 'gate_ctrl'
> linux-next-20090108/drivers/media/video/cx88/cx88-i2c.c:128: error: 'struct cx88_core' has no member named 'gate_ctrl'

Grrr... a small trivial bug... Anyway, trival to fix also.

Cheers,
Mauro
