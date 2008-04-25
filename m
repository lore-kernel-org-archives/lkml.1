Return-Path: <linux-kernel-owner+w=401wt.eu-S1761383AbYDYJT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383AbYDYJT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 05:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758692AbYDYJTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 05:19:46 -0400
Received: from ns.store20.com ([212.7.7.16]:53323 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758602AbYDYJTq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 05:19:46 -0400
Subject: Re: [REGRESSION] x86: support for new UV apic
From: Priit Laes <plaes@plaes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@sgi.com>, Gabriel C <nix.or.die@googlemail.com>
In-Reply-To: <20080425064405.GA23043@elte.hu>
References: <1209098600.3707.13.camel@localhost>
	 <20080425064405.GA23043@elte.hu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Fri, 25 Apr 2008 12:19:42 +0300
Message-Id: <1209115182.3857.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ühel kenal päeval, R, 2008-04-25 kell 08:44, kirjutas Ingo Molnar:
> * Priit Laes <plaes@plaes.org> wrote:
> 
> > Hey,
> > 
> > I am getting two following warnings (probable one per each CPU core) 
> > using the latest Linus's git:
> > 
> > WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x30/0x62()
> > Modules linked in:
> > Pid: 1, comm: swapper Not tainted 2.6.25-03563-gf7288b1 #20
> 
> thanks - could you check the patch below, does it fix the warnings?

Works for me!

Thanks :)

--
Priit Laes
