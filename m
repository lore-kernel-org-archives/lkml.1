Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZJNGoC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZJNGoC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:44:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbZJNGoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:44:01 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:51672 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbZJNGoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:44:00 -0400
Message-ID: <4AD5730A.20906@msgid.tls.msk.ru>
Date: Wed, 14 Oct 2009 10:43:22 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [GIT PULL] kbuild fixes
References: <20091011221818.GA2833@merkur.ravnborg.org> <4AD2EBC6.1000505@msgid.tls.msk.ru> <20091013185841.GC5249@merkur.ravnborg.org> <4AD4D2D8.5000904@msgid.tls.msk.ru> <20091013202036.GA5373@merkur.ravnborg.org>
In-Reply-To: <20091013202036.GA5373@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Tue, Oct 13, 2009 at 11:19:52PM +0400, Michael Tokarev wrote:
>> Sam Ravnborg wrote:
[]
>>> And please - do not even think of asking me to do it.

>> How many patches should one send? How many trees one should
>> compare against and send different patch for, in case such
>> an obvious trivial cases?  If I'll provide this against
>> mainline, it wont apply to Sam's tree.

> mainline - a replacement patch would have been
> what I had expected to see.

That's what I didn't think of.  Due to the "trivialness" of
the whole thing (it's easier to go edit the target file
directly than to apply patches), and because.. well.. it
didn't occur to me ;)

> I took you patch and gave it a hopefully proper
> subject and applied it to kbuild-fixes.git.

Thank you Sam.

/mjt
