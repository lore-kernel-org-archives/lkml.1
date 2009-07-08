Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbZGHRNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbZGHRNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbZGHRNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:13:10 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3781 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbZGHRNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:13:10 -0400
Subject: Re: [PATCH] Remove multiple KERN_ prefixes from printk formats
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0907061332040.3210@localhost.localdomain>
References: <4A4C3410.8080704@kernel.org>
	 <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain>
	 <1246513356.28915.62.camel@Joe-Laptop.home>
	 <alpine.LFD.2.01.0907021020200.4830@localhost.localdomain>
	 <1246556320.28915.92.camel@Joe-Laptop.home>
	 <alpine.LFD.2.01.0907021043160.4830@localhost.localdomain>
	 <1246910740.4643.10.camel@Joe-Laptop.home>
	 <8bd0f97a0907061323j3480fa61sa7f44d71819a076d@mail.gmail.com>
	 <alpine.LFD.2.01.0907061332040.3210@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 10:11:19 -0700
Message-Id: <1247073079.25028.0.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-06 at 13:05 -0700, Joe Perches wrote: 
> Hi Linus, let me know if you want this submitted as a
> patchset to each maintainer or if you simply want this
> rolled-up patch.

On Mon, 2009-07-06 at 13:33 -0700, Linus Torvalds wrote:
> So unless you want an _empty_ line due to an earlier '\n', the change is 
> correct.

Linus, do you want this patch at all?

These changes do fix newly introduced log errors caused
by commit 5fd29d6ccbc98884569d6f3105aeca70858b3e0f

