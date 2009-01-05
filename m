Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZAETvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZAETvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZAETvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:51:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56644 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbZAETvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:51:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Cheng Renquan (=?utf-8?q?=E7=A8=8B=E4=BB=BB=E5=85=A8?=)" 
	<crquan@gmail.com>
Subject: Re: KPROBE linking error (who's the maintainer of kernel/power/) ?
Date: Mon, 5 Jan 2009 20:51:29 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-tst; KDE/4.1.3; x86_64; ; )
Cc: "Arjan van de Ven" <arjan@linux.intel.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Matt Helsley" <matthltc@us.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       mhiramat@redhat.com, linux-kernel@vger.kernel.org,
       "Pavel Machek" <pavel@suse.cz>, linux-pm@lists.linux-foundation.org
References: <91b13c310901042312o44afa166t66b23e8ad10d104f@mail.gmail.com> <200901051416.04816.rjw@sisk.pl> <91b13c310901050855y7cdee2c2yc8a03c4e1a4ac109@mail.gmail.com>
In-Reply-To: <91b13c310901050855y7cdee2c2yc8a03c4e1a4ac109@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901052051.30256.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009, Cheng Renquan (程任全) wrote:
> On Mon, Jan 5, 2009 at 9:16 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> Furthermore, there seems no entry for maintainers of "kernel/power/",
> >> who maintain that subdir please add your name to the MAINTAINERS file?
> >> I just grab some latest touchers of kernel/power/ and kernel/kprobes.c
> >> as the recipients here.
> >
> > I'm one of the maintainers.
> 
> I found that linux-pm@lists.linux-foundation.org by searching your
> email in the MAINTAINERS file, in the section of "SUSPEND TO RAM" and
> "HIBERNATION", both not very apparently related to kernel/power/,
> maybe my careless, maybe we can improve it?

Well, kernel/power is mostly about hibernation and suspend to RAM, the freezer
is the only "other" thing.  It used to be suspend/hibernation-specific, though.

Thanks,
Rafael
