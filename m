Return-Path: <linux-kernel-owner+w=401wt.eu-S1751989AbZI1Ebf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbZI1Ebf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 00:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbZI1Ebe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 00:31:34 -0400
Received: from [195.41.46.235] ([195.41.46.235]:42094 "EHLO pfepa.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbZI1Ebe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 00:31:34 -0400
Date: Mon, 28 Sep 2009 06:31:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeff Dike <jdike@addtoit.com>, Ingo Molnar <mingo@elte.hu>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de, David.Woodhouse@intel.com
Subject: Re: [tip:x86/kbuild] x86: Don't silently override CONFIG_64BIT in
	'make oldconfig'
Message-ID: <20090928043131.GA10652@merkur.ravnborg.org>
References: <tip-5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9@git.kernel.org> <20090904144857.GA12872@elte.hu> <alpine.LFD.2.00.0909041631210.14872@twosheds.infradead.org> <4AA13FE6.20807@zytor.com> <20090904183103.GA1873@elte.hu> <4AA16336.3050606@zytor.com> <20090911211654.GA11399@c2.user-mode-linux.org> <4AAED1E2.7060906@zytor.com> <20090915033334.GA16531@c2.user-mode-linux.org> <4ABC8773.7010104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABC8773.7010104@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 02:03:47AM -0700, H. Peter Anvin wrote:
> Jeff Dike wrote:
>> On Mon, Sep 14, 2009 at 04:29:38PM -0700, H. Peter Anvin wrote:
>>> Jeff, could you re-send this as a proper patch with an SOB line?
>>
>> I could - I wanted to get it out for comment first in case anyone had
>> any conniptions, especially about moving the include of the arch
>> Makefile.
>>
>> I'll take another look at it tomorrow and send it out properly...
>>
>> 				Jeff
>
> Ping on this?  Also, Sam, it would be great if you could comment on the  
> patch:
>
>     http://marc.info?i=20090911211654.GA11399@c2.user-mode-linux.org

I took a quick look at it this weekend. My first reaction was that um
is now again doing it best to workaround something rather than to
use something.

But I have not had time to come up with any alternative proposal.
I may give it a spin the coming weekend.

	Sam
