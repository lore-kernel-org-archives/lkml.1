Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYGPLjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYGPLjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 07:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbYGPLjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 07:39:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39386 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516AbYGPLjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 07:39:24 -0400
Date: Wed, 16 Jul 2008 07:39:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Florian Weimer <fw@deneb.enyo.de>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Elias Oltmanns <eo@nebensachen.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH -v2] ftrace: Documentation
In-Reply-To: <871w1u5edg.fsf@mid.deneb.enyo.de>
Message-ID: <Pine.LNX.4.58.0807160737250.31086@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
 <87zlop7bp6.fsf@denkblock.local> <20080710132832.38cc5048.randy.dunlap@oracle.com>
 <Pine.LNX.4.58.0807101956120.7719@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0807102035550.7719@gandalf.stny.rr.com> <871w1u5edg.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 16 Jul 2008, Florian Weimer wrote:

>
> * Steven Rostedt:
>
> > +  License:   The GNU Free Documentation License, Version 1.2
>
> Is it really a good idea to put files under GPL-incompatible licenses
> into the tree?
>

The document is not code. The GPL is not appropriate for it. I had this
discussion when I wrote the rt-mutex-design.txt file, and the conclussion
was that the GFDL was an appropriate license.

-- Steve

