Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZALMyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZALMyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZALMx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:53:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbZALMx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:53:58 -0500
Subject: Re: [PULL -tip] x86: fix style problems in microcode_intel.c,
	msr.c and module_XX.c
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       "H. Peter Anvin" <hpa@kernel.org>, tigran@aivazian.fsnet.co.uk,
       shaohua.li@intel.com, rusty@rustcorp.com.au,
       Andi Kleen <andi@firstfloor.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090112104429.GE10405@elte.hu>
References: <1231753169.7087.5.camel@jaswinder.satnam>
	 <20090112102011.GB10405@elte.hu>
	 <3f9a31f40901120243u5ca60bc6n31dee913a02a081a@mail.gmail.com>
	 <20090112104429.GE10405@elte.hu>
Content-Type: text/plain; charset=utf8
Date: Mon, 12 Jan 2009 18:21:17 +0530
Message-Id: <1231764677.10461.8.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-12 at 11:44 +0100, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
> 
> > On Mon, Jan 12, 2009 at 3:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > hm, are the mpparse.c structural cleanups that i suggested some time ago
> > > still on your list? I think the functions replace_intsrc_all(),
> > > smp_scan_config() and smp_read_mpc() need those cleanups.
> > >
> > 
> > Yes, it is still in my TODO list. But before that I need to submit
> > patches to get some extra space:
> > 0001-x86-replacing-mp_config_ioapic-with-mpc_ioapic.patch
> > 0002-x86-replacing-mp_config_intsrc-with-mpc_intsrc.patch
> > 
> > And then I will make final changes in mpparse.c
> 
> ok.
> 

I send ﻿[PULL -tip] x86: replacing mp_config_X with mpc_X which
includes:

﻿  x86: replacing mp_config_ioapic with mpc_ioapic
  x86: replacing mp_config_intsrc with mpc_intsrc

--
JSR

