Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbZIYJJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbZIYJJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 05:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZIYJJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 05:09:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40168 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbZIYJJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 05:09:10 -0400
Message-ID: <4ABC8773.7010104@zytor.com>
Date: Fri, 25 Sep 2009 02:03:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de, David.Woodhouse@intel.com
Subject: Re: [tip:x86/kbuild] x86: Don't silently override CONFIG_64BIT in
 'make oldconfig'
References: <tip-5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9@git.kernel.org> <20090904144857.GA12872@elte.hu> <alpine.LFD.2.00.0909041631210.14872@twosheds.infradead.org> <4AA13FE6.20807@zytor.com> <20090904183103.GA1873@elte.hu> <4AA16336.3050606@zytor.com> <20090911211654.GA11399@c2.user-mode-linux.org> <4AAED1E2.7060906@zytor.com> <20090915033334.GA16531@c2.user-mode-linux.org>
In-Reply-To: <20090915033334.GA16531@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> On Mon, Sep 14, 2009 at 04:29:38PM -0700, H. Peter Anvin wrote:
>> Jeff, could you re-send this as a proper patch with an SOB line?
> 
> I could - I wanted to get it out for comment first in case anyone had
> any conniptions, especially about moving the include of the arch
> Makefile.
> 
> I'll take another look at it tomorrow and send it out properly...
> 
> 				Jeff

Ping on this?  Also, Sam, it would be great if you could comment on the 
patch:

     http://marc.info?i=20090911211654.GA11399@c2.user-mode-linux.org

	-hpa

