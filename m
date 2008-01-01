Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYAAOeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYAAOeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 09:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754076AbYAAOeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 09:34:09 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50501 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753812AbYAAOeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 09:34:08 -0500
Date: Tue, 1 Jan 2008 14:25:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Shannon Nelson <shannon.nelson@intel.com>, dan.j.williams@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] #if 0 dma_async_memcpy_buf_to_buf()
Message-ID: <20080101142531.787084d5@the-village.bc.nu>
In-Reply-To: <20080101134924.GR2360@does.not.exist>
References: <20080101134924.GR2360@does.not.exist>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jan 2008 15:49:24 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> This patch #if 0's the unused dma_async_memcpy_buf_to_buf().
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

NAK. Yet again you are trying to remove bits of APIs in ways that make
no sense.

