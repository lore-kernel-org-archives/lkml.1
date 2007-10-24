Return-Path: <linux-kernel-owner+w=401wt.eu-S1758382AbXJXRQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbXJXRQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbXJXRQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:16:49 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41553 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753099AbXJXRQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:16:48 -0400
Date: Wed, 24 Oct 2007 18:19:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] unexport sys_{open,read}
Message-ID: <20071024181935.1302b1e1@the-village.bc.nu>
In-Reply-To: <20071024162434.GL30533@stusta.de>
References: <20071024162434.GL30533@stusta.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 18:24:34 +0200
Adrian Bunk <bunk@kernel.org> wrote:

> sys_{open,read} can finally be unexported.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Alan Cox <alan@redhat.com>
