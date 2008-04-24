Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbYDXKqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbYDXKqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 06:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYDXKqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 06:46:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:32945 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751581AbYDXKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 06:46:22 -0400
Date: Thu, 24 Apr 2008 11:17:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: ben-linux@fluff.org, Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: s3c2410: platform_get_irq() may return signed
 unnoticed
Message-ID: <20080424111745.18d39576@the-village.bc.nu>
In-Reply-To: <480FB148.5000704@tiscali.nl>
References: <480FB148.5000704@tiscali.nl>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008 23:59:36 +0200
Roel Kluin <12o3l@tiscali.nl> wrote:

> dev->irq is unsigned, platform_get_irq() may return signed unnoticed
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Acked-by: Alan Cox <alan@redhat.com>
