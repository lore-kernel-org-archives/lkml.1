Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbYJMKTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbYJMKTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762825AbYJMKRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:17:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54294 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932692AbYJMKRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:17:00 -0400
Date: Mon, 13 Oct 2008 11:16:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: alan@redhat.com, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH 0/6] Blackfin Serial Driver updates for 2.6.28
Message-ID: <20081013111641.100eea07@lxorguk.ukuu.org.uk>
In-Reply-To: <1223891185-13924-1-git-send-email-cooloney@kernel.org>
References: <1223891185-13924-1-git-send-email-cooloney@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008 17:46:19 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> 
> Hi Alan,
> 
> This is Blackfin serial driver updates:
> 
>  - rewrite kgdb over serial supporting
>  - some bug fixing

Queued for once the current tty patches have appeared in Linus tree.
