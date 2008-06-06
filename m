Return-Path: <linux-kernel-owner+w=401wt.eu-S1762085AbYFFPVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762085AbYFFPVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758621AbYFFPUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:20:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53404 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757969AbYFFPUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:20:51 -0400
Date: Fri, 6 Jun 2008 16:04:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Catalin(ux) M BOIE" <catab@embedromix.ro>
Cc: linux-kernel@vger.kernel.org, rmk+serial@arm.linux.org.uk,
       linux-serial@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Add support for a no-name 4 ports multiserial card
Message-ID: <20080606160428.151e7ece@core>
In-Reply-To: <484930A3.1020103@embedromix.ro>
References: <1212736393-6837-1-git-send-email-catab@embedromix.ro>
	<20080606111400.1eefc4fd@core>
	<484930A3.1020103@embedromix.ro>
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

> > Either the hex or a local and obviously unknown name like ID_UNKNOWN_1
> 
> Do you agree to use ID_UNKNOWN_0x1584?

Excellent idea


> And here pbn_plx_unknown_0x1584?

Ditto

Acked-by: Alan Cox <alan@redhat.com>

Alan
