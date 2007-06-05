Return-Path: <linux-kernel-owner+w=401wt.eu-S1763861AbXFERJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763861AbXFERJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758872AbXFERJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:09:39 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:48161 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXFERJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:09:38 -0400
Date: Tue, 5 Jun 2007 13:09:36 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bzolnier@gmail.com, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 3/6] lguest suppress IDE probing
In-Reply-To: <20070605170747.256f6631@the-village.bc.nu>
Message-ID: <Line.LNX.4.64.0706051308480.22117@d.namei>
References: <1181055308.14054.36.camel@localhost.localdomain>
 <1181055396.14054.38.camel@localhost.localdomain>
 <1181055483.14054.40.camel@localhost.localdomain> <20070605170747.256f6631@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Alan Cox wrote:

> Better yet just don't compile in the old IDE stuff, lguest doesn't have a
> PCI or ISA bus anyway.

The guest & host kernels are intended to be identical, so we could expect
pretty much anything to be compiled in to the guest. 

The other two suggestions sound better.


- James
-- 
James Morris
<jmorris@namei.org>
