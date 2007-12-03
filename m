Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbXLCRLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbXLCRLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 12:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbXLCRLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 12:11:11 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36814 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751359AbXLCRLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 12:11:10 -0500
Date: Mon, 3 Dec 2007 17:06:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]
Message-ID: <20071203170634.118a125a@the-village.bc.nu>
In-Reply-To: <20071203155451.GA2594@mette>
References: <20071203155451.GA2594@mette>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007 16:54:55 +0100
"Andries E. Brouwer" <Andries.Brouwer@cwi.nl> wrote:

> As it turns out, the kernel divides by EXT3_INODES_PER_GROUP(s)
> when mounting an ext3 filesystem. If that number is zero,
> a crash follows. Below a patch.
> 
> This crash was reported by Joeri de Ruiter, Carst Tankink and Pim Vullers.

Acked-by: Alan Cox <alan@redhat.com>
