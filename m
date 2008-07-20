Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbYGTJgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbYGTJgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 05:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbYGTJgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 05:36:42 -0400
Received: from www17.your-server.de ([213.133.104.17]:34078 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbYGTJgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 05:36:41 -0400
Subject: Re: linux-next: Tree for July 18: warning at kernel/lockdep.c:2068
	trace_hardirqs_on_caller
From: Thomas Meyer <thomas@m3y3r.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Greg KH <gregkh@suse.de>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Stephen Rothwell <sfr@canb.auug.org.au>, kernel-testers@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Bernhard Walle <bwalle@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>,
       kexec <kexec@lists.infradead.org>
In-Reply-To: <1216544462.9311.20.camel@nimitz>
References: <20080718195352.e562a00f.sfr@canb.auug.org.au>
	 <200807190928.33978.m.kozlowski@tuxland.pl>
	 <19f34abd0807190255x304173d4wf2bfabb2d5bce511@mail.gmail.com>
	 <19f34abd0807190559y2fe5ebf9h7095793e82de3122@mail.gmail.com>
	 <20080719221723.GB5578@suse.de>
	 <19f34abd0807191527u61c5ed61kffe2279c8d46915d@mail.gmail.com>
	 <19f34abd0807191544nfd73be5nf7dde4b61992a7e8@mail.gmail.com>
	 <20080719225817.GA6264@suse.de>
	 <19f34abd0807191611y7cabf405iad307ba79591e04f@mail.gmail.com>
	 <1216544462.9311.20.camel@nimitz>
Content-Type: text/plain
Date: Sun, 20 Jul 2008 11:35:46 +0200
Message-Id: <1216546546.3217.0.camel@dhcppc2>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 20.07.2008, 02:01 -0700 schrieb Dave Hansen:
> On Sun, 2008-07-20 at 01:11 +0200, Vegard Nossum wrote:
> > Maybe the firmware memmap code can simply run a little later in the
> > boot sequence?
> 
> Heh, I'm catching up on this thread...
> 

On that thread?

http://lkml.org/lkml/2008/7/15/108



