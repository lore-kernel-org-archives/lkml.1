Return-Path: <linux-kernel-owner+w=401wt.eu-S1762654AbXEYNkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762654AbXEYNkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 09:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbXEYNkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 09:40:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54390 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751348AbXEYNka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 09:40:30 -0400
Date: Fri, 25 May 2007 06:40:29 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <20070525061200.GG7653@kernel.dk>
Message-ID: <Pine.LNX.4.64.0705250639240.5199@schroedinger.engr.sgi.com>
References: <376320.95285.qm@web52612.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0705221524490.16904@schroedinger.engr.sgi.com>
 <20070523071103.GE4705@kernel.dk> <Pine.LNX.4.64.0705231003460.19822@schroedinger.engr.sgi.com>
 <20070524072550.GC15375@kernel.dk> <Pine.LNX.4.64.0705240953270.28086@schroedinger.engr.sgi.com>
 <20070525061200.GG7653@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, Jens Axboe wrote:

> The .config I sent is the one that the last boot of the machine was
> based on. The kernel is 2.6.22-rc2 with the patch moving the #ifdef from
> you, and it works for me with or without CONFIG_SLUB_DEBUG set.

I was not talking about your config but the .config that started this 
thread.


