Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbYEYNW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbYEYNW6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 09:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYEYNWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 09:22:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37287 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751298AbYEYNWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 09:22:21 -0400
Date: Sun, 25 May 2008 14:06:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, akpm@linux-foundation.org
Subject: Re: [PATCHv2 01/28] libertas: treat firmware data as const
Message-ID: <20080525140632.0874634c@core>
In-Reply-To: <E1K0DNx-0007Cq-Uy@shinybook.infradead.org>
References: <1211708969@pmac.infradead.org>
	<E1K0DNx-0007Cq-Uy@shinybook.infradead.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008 11:23:29 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> ---
>  drivers/net/wireless/libertas/if_cs.c   |    2 +-
>  drivers/net/wireless/libertas/if_sdio.c |    4 ++--
>  drivers/net/wireless/libertas/if_usb.c  |    4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)

Acked-by: Alan Cox <alan@redhat.com>
