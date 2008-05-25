Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbYEYNWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbYEYNWn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 09:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYEYNWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 09:22:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37286 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751281AbYEYNWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 09:22:21 -0400
Date: Sun, 25 May 2008 14:07:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, akpm@linux-foundation.org
Subject: Re: [PATCHv2 02/28] bluetooth: treat firmware data as const
Message-ID: <20080525140711.0c0917e7@core>
In-Reply-To: <E1K0DNz-0007Cu-0C@shinybook.infradead.org>
References: <1211708969@pmac.infradead.org>
	<E1K0DNz-0007Cu-0C@shinybook.infradead.org>
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

On Sun, 25 May 2008 11:23:31 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> ---
>  drivers/bluetooth/bfusb.c   |    3 ++-
>  drivers/bluetooth/bt3c_cs.c |    3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)

Acked-by: Alan Cox <alan@redhat.com>
