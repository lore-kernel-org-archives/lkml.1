Return-Path: <linux-kernel-owner+w=401wt.eu-S1759776AbYE2WMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776AbYE2WMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 18:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759585AbYE2WLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 18:11:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42358 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759462AbYE2WLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 18:11:51 -0400
Date: Thu, 29 May 2008 22:57:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [RFC PATCH] libata-sff: Fix oops reported in kerneloops.org for
 pnp devices with no ctl
Message-ID: <20080529225748.40f19026@core>
In-Reply-To: <483F26B0.8010006@garzik.org>
References: <20080529161453.24735.805.stgit@core>
	<alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org>
	<20080529190235.258d304e@core>
	<483EF536.90801@garzik.org>
	<20080529194238.36458a46@core>
	<483F049E.2090809@garzik.org>
	<20080529221058.1169e140@core>
	<20080529223755.12610b87@core>
	<483F26B0.8010006@garzik.org>
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

> Honestly I think your first RFC PATCH (dated Thu, 29 May 2008 22:10:58 
> +0100) turned out better than this.
> 
> NO_ALTSTATUS is a bit ugly, don't you think?

I do , but Linus seemed to like it ;)
> 
> In any case, based on a quick review I would certainly ack the first RFC 
> PATCH.

Ok. I'll run a full test set on that one tomorrow
