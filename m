Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbZJPS5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbZJPS5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbZJPS5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:57:20 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:52947 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750833AbZJPS5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:57:20 -0400
Date: Fri, 16 Oct 2009 14:49:43 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: allow stats to be cleared
In-Reply-To: <alpine.DEB.1.00.0910161129320.21328@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0910161449300.14329@gentwo.org>
References: <alpine.DEB.1.00.0910150215320.1551@chino.kir.corp.google.com> <alpine.DEB.1.10.0910161249100.6120@gentwo.org> <alpine.DEB.1.00.0910161129320.21328@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009, David Rientjes wrote:

> On a semi-related topic, it would have been nice to isolate all statistic
> files to its own directory: /sys/kernel/slab/kmalloc-256/stats/..., for
> example.  It would have made collecting (and now clearing) all statistics
> much easier since userspace wouldn't need a predefined list of stat file
> names to scan.  I wonder if Pekka would allow them to be moved...

I am for it.

