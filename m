Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbZCYVAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbZCYVAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZCYU77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 16:59:59 -0400
Received: from www.tglx.de ([62.245.132.106]:50728 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbZCYU77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:59:59 -0400
Date: Wed, 25 Mar 2009 21:59:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>
Subject: [Announce] 2.6.29-rt1
In-Reply-To: <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain> <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain> <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain> <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain> <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain> <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain>
 <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.
 
     - port forward to 2.6.29 final

Download locations:

    http://rt.et.redhat.com/download/
    http://www.kernel.org/pub/linux/kernel/projects/rt/
 
Information on the RT patch can be found at:

    http://rt.wiki.kernel.org/index.php/Main_Page

to build the 2.6.29-rt1 tree, the following patches should be
applied:

    http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29.tar.bz2
    http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rt1.bz2

The broken out patches are also available at the same download
locations.

Enjoy !

       tglx

