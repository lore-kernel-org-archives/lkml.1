Return-Path: <linux-kernel-owner+w=401wt.eu-S1759461AbYGPK7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbYGPK7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 06:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756836AbYGPK7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 06:59:20 -0400
Received: from mail.enyo.de ([212.9.189.167]:56540 "EHLO mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581AbYGPK7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 06:59:19 -0400
X-Greylist: delayed 2913 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2008 06:59:19 EDT
From: Florian Weimer <fw@deneb.enyo.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Elias Oltmanns <eo@nebensachen.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH -v2] ftrace: Documentation
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
	<87zlop7bp6.fsf@denkblock.local>
	<20080710132832.38cc5048.randy.dunlap@oracle.com>
	<Pine.LNX.4.58.0807101956120.7719@gandalf.stny.rr.com>
	<Pine.LNX.4.58.0807102035550.7719@gandalf.stny.rr.com>
Date: Wed, 16 Jul 2008 12:10:03 +0200
In-Reply-To: <Pine.LNX.4.58.0807102035550.7719@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Thu, 10 Jul 2008 20:37:19 -0400 (EDT)")
Message-ID: <871w1u5edg.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt:

> +  License:   The GNU Free Documentation License, Version 1.2

Is it really a good idea to put files under GPL-incompatible licenses
into the tree?
