Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYAAOc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYAAOc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 09:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYAAOcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 09:32:20 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50493 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753518AbYAAOcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 09:32:20 -0500
Date: Tue, 1 Jan 2008 14:23:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
Message-ID: <20080101142344.769f16c7@the-village.bc.nu>
In-Reply-To: <20080101134809.GK2360@does.not.exist>
References: <20080101134809.GK2360@does.not.exist>
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

On Tue, 1 Jan 2008 15:48:09 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> This patch removes the EXPERIMENTAL option and all dependencies on
> EXPERIMENTAL since they are pointless.

NAK

Experimental is an important guide to driver and code quality. 

"It might have been differently 10 years ago, but today everything that
 is available in a released kernel should also be in a usable state."

Usable does not equal non-experimental. 

>	This patch has been sent on:
>	 11 Dec 2007
>	 25 Nov 2007
>	 17 Nov 2007

So why not drop it instead. It clearly has no consensus
