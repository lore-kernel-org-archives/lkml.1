Return-Path: <linux-kernel-owner+w=401wt.eu-S935869AbZDISzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935869AbZDISzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758917AbZDISyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:54:47 -0400
Received: from www.tglx.de ([62.245.132.106]:43942 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761655AbZDISyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:54:46 -0400
Date: Thu, 9 Apr 2009 20:53:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>
Subject: [Announce] 2.6.29.1-rt6
In-Reply-To: <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain> <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain> <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain> <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain> <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain> <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain>
 <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain> <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain> <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain> <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>
 <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.

  	- rt locks fixes (Jan Blunck, tglx)
	- kvm vs. -rt fixes (Jan Blunck)
	- hpet interrupt fix (tglx, reported and tested by Hans Peter Bock)

Download locations:

     http://rt.et.redhat.com/download/
     http://www.kernel.org/pub/linux/kernel/projects/rt/

Information on the RT patch can be found at:

     http://rt.wiki.kernel.org/index.php/Main_Page

to build the 2.6.29.1-rt6 tree, the following patches should be
applied:

     http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.29.1.tar.bz2
     http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29.1-rt6.bz2

The broken out patches are also available at the same download
locations.

Enjoy !

       tglx

