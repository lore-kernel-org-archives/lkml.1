Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbXGKW5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbXGKW5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762113AbXGKW4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:56:53 -0400
Received: from depni.sinp.msu.ru ([213.131.7.21]:53936 "EHLO depni.sinp.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761589AbXGKW4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:56:52 -0400
X-Greylist: delayed 1388 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2007 18:56:52 EDT
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Orr <martin@martinorr.name>, Stefano Rivoir <s.rivoir@gts.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matthias Klose <doko@debian.org>
Subject: Re: Linux 2.6.22 released
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
	<4693327E.6000006@gts.it>
	<alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org>
	<46947ADF.4080605@gts.it> <p73vecrxf0t.fsf@bingen.suse.de>
	<46951892.20406@martinorr.name>
	<alpine.LFD.0.999.0707111059200.3412@woody.linux-foundation.org>
	<469544D3.90004@martinorr.name>
	<alpine.LFD.0.999.0707111410430.20061@woody.linux-foundation.org>
	<20070711221626.GA25510@one.firstfloor.org>
From: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Date: Thu, 12 Jul 2007 02:33:42 +0400
In-Reply-To: <20070711221626.GA25510@one.firstfloor.org> (Andi Kleen's message of "Thu\, 12 Jul 2007 00\:16\:26 +0200")
Message-ID: <87hcoa6055.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/23.0.0 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>> I don't think this is worth even trying to fix. This is terminal compiler 
>> breakage. Make a bug-report to the gcc people, the inline asm stuff has 
>> been totally buggered by that compiler version.
>> 
>> If it mis-compiled that part, it probably miscompiled a lot of other 
>> things too.
>
> I just checked with today's gcc 4.2 (070711) freshly compiled and from a quick inspection 
> the code looks correct again. So perhaps it has been already fixed? 

No, debian's 4.2-20070707-1 is made from another branch (branches/ubuntu/gcc-4_2-branch)

CC'ing Debian GCC Maintainer, he will be interested.
