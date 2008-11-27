Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYK0NeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYK0NeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbYK0Ndm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:33:42 -0500
Received: from www.tglx.de ([62.245.132.106]:36029 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621AbYK0Ndl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:33:41 -0500
Date: Thu, 27 Nov 2008 14:32:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@gmail.com
cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
In-Reply-To: <7c86c4470811270431n5cf1b863tc4f8c7829283e332@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811271430470.3325@localhost.localdomain>
References: <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com>  <20081127113115.GH6703@one.firstfloor.org>  <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com>  <20081127.034247.72331360.davem@davemloft.net> 
 <alpine.LFD.2.00.0811271246200.3325@localhost.localdomain>  <20081127123811.GJ6703@one.firstfloor.org> <7c86c4470811270431n5cf1b863tc4f8c7829283e332@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008, stephane eranian wrote:
> That's true for Intel.
> On AMD64, I think you can get at most one sample out of a irq-off
> region using IBS.

Exactly the same amount which you get with the NMI/self_IPI out of an
irq-off region.
 
Thanks,

	tglx
