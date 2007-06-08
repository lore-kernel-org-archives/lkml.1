Return-Path: <linux-kernel-owner+w=401wt.eu-S969439AbXFHPYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969439AbXFHPYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968803AbXFHPYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:24:01 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58320 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S967406AbXFHPX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:23:59 -0400
Date: Fri, 8 Jun 2007 16:28:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Florin Iucha <florin@iucha.net>, Robert Hancock <hancockr@shaw.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@kernel.vger.org, jeff@garzik.org
Subject: Re: [PATCH] libata: disable NCQ for HITACHI
 HTS541680J9SA00/SB21C7EP
Message-ID: <20070608162859.1f76f6d6@the-village.bc.nu>
In-Reply-To: <20070608132059.GG29122@htj.dyndns.org>
References: <fa.Nigm+GFAuAW+QzfgqTUfmHJoFfU@ifi.uio.no>
	<4666C477.1070603@shaw.ca>
	<20070607120430.GB30661@iucha.net>
	<466951DE.9070004@gmail.com>
	<20070608131157.GH30661@iucha.net>
	<20070608132059.GG29122@htj.dyndns.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 22:20:59 +0900
Tejun Heo <htejun@gmail.com> wrote:

> HITACHI HTS541680J9SA00/SB21C7EP spuriously completes NCQ commands.
> Blacklist it for NCQ.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>

Acked-by: Alan Cox <alan@redhat.com>
