Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZDOTgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZDOTgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 15:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZDOTgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 15:36:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:46983 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbZDOTgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 15:36:32 -0400
Message-ID: <49E636F2.7030902@kernel.org>
Date: Wed, 15 Apr 2009 12:35:14 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joerg Roedel <joerg.roedel@amd.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [PATCH] x86: used used_vectors in init_IRQ
References: <49E62DFD.6010904@kernel.org> <20090415192550.GA27004@elte.hu>
In-Reply-To: <20090415192550.GA27004@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> Note, i removed the -stable tag because i dont think .29 nor .30-rc2 
> is affected. Your patch to irqinit*.c (and the later unification by 
> Pekka) is something still pending in the perfcounters and x86 trees, 
> queued for .31.
> 

not sure .29, but it seems we need this for 2.6.30

or you want me to produce one against to linus tree?

YH
