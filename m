Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbXENA1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbXENA1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 20:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757330AbXENA1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 20:27:00 -0400
Received: from terminus.zytor.com ([192.83.249.54]:60817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbXENA1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 20:27:00 -0400
Message-ID: <4647ACA5.7040901@zytor.com>
Date: Sun, 13 May 2007 17:26:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Riley@Williams.Name
Subject: Re: MAINTAINERS update.
References: <20070513230746.GA3607@redhat.com> <46479AFC.7020404@zytor.com> <20070513232953.GJ27604@redhat.com>
In-Reply-To: <20070513232953.GJ27604@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> 
> That previous entry of MAINTAINERS raised an eyebrow too.
> You, Eric, Andi, and Zach seem to have done more work on 'i386 BOOT CODE'
> in the last few months than I recall Riley doing, well.. since ages.
> Not to belittle whatever work he did, but perhaps his entry belongs
> more in CREDITS than MAINTAINERS.  It felt a little cheeky to be
> messing with someone elses entry though.  Riley?
> 

Riley passed away about a month ago (traffic accident.)

Anyway I have a patch to take over maintainership of that as part of my
rewrite of said code:

http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-newsetup.git;a=summary

> Perhaps those two entries should just be merged together to become
> "i386 Architecture" too ?

That would not be a bad idea; overall, though, I think a lot more code
should be unified across the entire x86 architecture.

	-hpa
