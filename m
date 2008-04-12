Return-Path: <linux-kernel-owner+w=401wt.eu-S1758648AbYDLTRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbYDLTRv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757569AbYDLTRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:17:41 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43920 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106AbYDLTRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:17:40 -0400
Subject: Re: Realtek 8111c weirdness problems, apic/msi, and normal bug
From: Kasper Sandberg <lkml@metanurb.dk>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Andrew Morton <akpm@osdl.org>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>
In-Reply-To: <20080412180850.GA17180@electric-eye.fr.zoreil.com>
References: <1207407804.14885.27.camel@localhost>
	 <20080405232354.57ff2fac.akpm@linux-foundation.org>
	 <20080406140624.GA24479@electric-eye.fr.zoreil.com>
	 <1207541340.30698.18.camel@localhost> <1207829872.1514.3.camel@localhost>
	 <20080412180850.GA17180@electric-eye.fr.zoreil.com>
Content-Type: text/plain
Date: Sat, 12 Apr 2008 21:15:44 +0200
Message-Id: <1208027744.1514.53.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-12 at 20:08 +0200, Francois Romieu wrote:
> Kasper Sandberg <lkml@metanurb.dk> :
> [...]
> > hmm, is this dmesg cut off? (its right after booting, but maybe the
> > buffer isnt big enough?)
> 
> Probably. So I have to ask which kernel it related to :o)
> 
that was .25-rc8-git3
i also posted for git8 later down in thread, along with from .23..



