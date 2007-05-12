Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbXELTPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbXELTPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbXELTPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:15:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54518 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756395AbXELTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:15:30 -0400
Date: Sat, 12 May 2007 20:19:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Glines <mark@glines.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] ip_local_port_range sysctl has annoying default
Message-ID: <20070512201942.74e85edf@the-village.bc.nu>
In-Reply-To: <20070512121009.18c8b68a@chirp>
References: <20070511170135.7c38615f@chirp>
	<4645227F.3030905@zytor.com>
	<20070512121009.18c8b68a@chirp>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, in that case, is there anything wrong with just using the
> range IANA recommends, in all cases?
> 
> Please consider this patch instead of my previous one.

Please send this patch to the netdev list and CC the relevant networking
maintainer.

Alan
