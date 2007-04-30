Return-Path: <linux-kernel-owner+w=401wt.eu-S1423149AbXD3H7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423149AbXD3H7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 03:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423148AbXD3H7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 03:59:50 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:51898 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423149AbXD3H7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 03:59:49 -0400
Date: Mon, 30 Apr 2007 09:59:35 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20070430075935.GA15437@linuxtv.org>
References: <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk> <20070428224904.GE3468@stusta.de> <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org> <p73d51n1fup.fsf@bingen.suse.de> <20070429235535.GC19937@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429235535.GC19937@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 87.162.91.65
Subject: Re: Linux 2.6.21
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007, Theodore Tso wrote:
> 
> Folks might want to take a look at the Debian Bug Tracking System
> (BTS).  It has a web interface which you can use to query history, but
> *everything* is e-mail driven, and the way you submit, close, update,
> tag/classfy bugs --- everything --- is via e-mail.

Plus it has the very user-friendly reportbug and querybts
commandline interfaces. No going to web pages to query
bugs, and you can just download the email thread for
a bug report as an mbox file and then reply via email.

(Querybts currently only works if you know the package
name, it can't search across all packages so it wouldn't
be that useful for the kernel. But for Debian packages
this tool is gold.)


Johannes
