Return-Path: <linux-kernel-owner+w=401wt.eu-S1765118AbXGKO2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765118AbXGKO2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 10:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762554AbXGKO2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 10:28:42 -0400
Received: from host28-104-static.26-213-b.business.telecomitalia.it ([213.26.104.28]:58644
	"EHLO zeus.san-lorenzo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760692AbXGKO2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 10:28:41 -0400
Message-ID: <4694E915.10607@gts.it>
Date: Wed, 11 Jul 2007 16:28:37 +0200
From: Stefano Rivoir <s.rivoir@gts.it>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Stefano Rivoir <s.rivoir@gts.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org> <4693327E.6000006@gts.it> <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org> <46947ADF.4080605@gts.it> <alpine.LFD.0.999.0707110002460.3412@woody.linux-foundation.org> <20070711105552.GG4887@tamriel.snowman.net>
In-Reply-To: <20070711105552.GG4887@tamriel.snowman.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Frost wrote:
> * Linus Torvalds (torvalds@linux-foundation.org) wrote:
>> I'm hoping your Debian/sid gcc version is some very experimental 
>> known-buggy one, and not something that people _expect_ to be solid and 
>> work well?
> 
> No such luck. :(  Debian's close to moving to gcc-4.2 as the default
> compiler in sid.  We've rebuilt the archive a number of times (both
> since the 4.2 release and during its development) using gcc-4.2 and
> thought we'd identified most of the issues with it.
> 
> It clearly sounds like we need to open a high-severity bug on this issue
> and track it down before we move to it as the default compiler.  I'll
> start harassing the appropriate folks also.
> 
> Stefano, can you file that bug, including the config, dmesg, and
> backtrace from gcc if you can get it?

Yes, I'll file a bug (here and on b.d.o) tonight, when I'll be on the 
box again.

Bye.

-- 
Stefano RIVOIR

