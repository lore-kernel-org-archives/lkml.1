Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbYFDMzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbYFDMzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYFDMzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:55:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42319 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbYFDMzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:55:24 -0400
Date: Wed, 4 Jun 2008 08:55:21 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: =?iso-8859-1?Q?J=FCrgen?= Mell <j.mell@t-online.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, hpa@zytor.com, tglx@linutronix.de,
       Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
In-Reply-To: <20080604105317.GA17874@elte.hu>
Message-ID: <Pine.LNX.4.58.0806040853320.18512@gandalf.stny.rr.com>
References: <200806011101.06491.j.mell@t-online.de> <20080602213756.GB25114@linux-os.sc.intel.com>
 <20080602225727.GC25114@linux-os.sc.intel.com> <200806040944.15815.j.mell@t-online.de>
 <20080604105317.GA17874@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 4 Jun 2008, Ingo Molnar wrote:
> * Jürgen Mell <j.mell@t-online.de> wrote:
> >
> > Thank you again!

No, thank YOU. What you gave was excellent feedback.

>
> fix applied to tip/x86/urgent. Thanks everyone, nice find!
>

Ingo, should this be forward to the stable branch?

-- Steve

