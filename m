Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab0BXBTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 20:19:25 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47200 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab0BXBTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 20:19:23 -0500
MIME-Version: 1.0
In-Reply-To: <49b7c2351002231708r279049f9hcc9cc6ff205a47fb@mail.gmail.com>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain>
	 <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain>
	 <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain>
	 <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain>
	 <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain>
	 <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain>
	 <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain>
	 <520f0cf11002220311l2a0caa83lf3ae2817b78501b6@mail.gmail.com>
	 <49b7c2351002231708r279049f9hcc9cc6ff205a47fb@mail.gmail.com>
Date: Wed, 24 Feb 2010 02:19:23 +0100
Message-ID: <25891f3e1002231719u4d38ed52w99c66ac669c3d965@mail.gmail.com>
Subject: Re: [ANNOUNCE] 2.6.33-rc8-rt1
From: Dhaval Giani <dhaval.lists@thegianis.in>
To: GeunSik Lim <leemgs1@gmail.com>
Cc: John Kacur <jkacur@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi GeunSik,

On Wed, Feb 24, 2010 at 2:08 AM, GeunSik Lim <leemgs1@gmail.com> wrote:
> Dear Thomas,
>
> This is a report  about booting test with linux-2.6.33.rc8-rt1 by Thomas.
> I also can't boot linux-2.6.33.rc8-rt1 version on my desktop pc like
> John Kacur. But, This Error message is different in my case.
> So, I returned linux version from this version to linux-2.6.31-rt14 version now.
> - version info : Linux-2.6.33.rc8-rt1
> - H/W Spec : intel Core2Quad Q9400 , SATA HDD320G
>
> I uploaded screenshot about booting error on my Q9400 based desktop pc.
> http://picasaweb.google.com/leemgs/LinuxRelatedScreenshot#5441436536331947314
>

Try the latest tip/rt/head and it should now be fixed up!

Thanks,
--
Dhaval
