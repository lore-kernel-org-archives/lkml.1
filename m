Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbXJNDRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbXJNDRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 23:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbXJNDRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 23:17:12 -0400
Received: from rwcrmhc14.comcast.net ([216.148.227.154]:65149 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbXJNDRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 23:17:11 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Oct 2007 23:17:11 EDT
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: x86: merge some trivially mergeable headers
X-Message-Flag: Warning: May contain useful information
X-Priority: 1
X-MSMail-Priority: High
References: <87bqb2u4ez.fsf@shaolin.home.digitalvampire.org>
	<alpine.LFD.0.9999.0710132307360.12017@localhost.localdomain>
From: Roland Dreier <roland@digitalvampire.org>
Date: Sat, 13 Oct 2007 20:12:08 -0700
In-Reply-To: <alpine.LFD.0.9999.0710132307360.12017@localhost.localdomain> (Thomas Gleixner's message of "Sat, 13 Oct 2007 23:12:46 +0200 (CEST)")
Message-ID: <871wbytmnr.fsf@shaolin.home.digitalvampire.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Roland, thanks for providing this. I have some of those already, but I 
 > really appreciate the help. I take yours and the previously posted and 
 > push them out into a cleanup branch on my x86 git tree.

No problem, this merging work is the perfect thing when I need a
break-- mindless enough to be relaxing, but useful enough that I don't
feel guilty...

Anyway, I assume you meant to write "I [will] take yours", since I
don't see anything at all in tglx/linux-2.6-x86.git right now.  I'll
check again on Monday and base my work on your tree.

 - R.
