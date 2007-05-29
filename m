Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbXE2Mxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbXE2Mxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbXE2MxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:53:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:36795 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbXE2MxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=R6wZPCgbVur42L7o7iRVGBaGTbK8GvtkQyWf2ftP8V1az9pF0O8fvJeQ7Sn2Ze845wvabbVNaSN2/rJ6rlD9RnPn7VuTDoaGRYdaephLXPQgWQCOUf6xgV//W6RtcpO+WYxRjrgCiGHPGaOFuT3Tg/cTE2ue1AaJJEIT2gDAIkM=
Message-ID: <465C222C.3020203@googlemail.com>
Date: Tue, 29 May 2007 14:53:00 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, video4linux@list.redhat.com,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Hans Verkuil <hverkuil@xs4all.nl>, Robert Fitzsimons <robfitz@273k.net>,
       Len Brown <lenb@kernel.org>, Thierry Volpiatto <tvolpiatt@neuf.fr>,
       Andi Kleen <ak@suse.de>, discuss@x86-64.org,
       Ioan Ionita <opslynx@gmail.com>
Subject: Re: [4/4] 2.6.22-rc3: known regressions
References: <465C188F.9000900@googlemail.com>
In-Reply-To: <465C188F.9000900@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc3.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



V4L

Subject    : V4L ABI breakage
References : http://lkml.org/lkml/2007/5/14/42
Submitter  : Robert Fitzsimons <robfitz@273k.net>
Caused-By  : Hans Verkuil <hverkuil@xs4all.nl>
             Mauro Carvalho Chehab <mchehab@infradead.org>
             commit 206ebaf32795cf1582b1e2ff2ec6a560c9e986b8
Workaround : http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=15ac2d293b08b6975c6ca1a80eb839d4cb0dddbf
Status     : problem is being debugged


x86-64

Subject    : x86-64 2.6.22-rc2 random segfaults
References : http://lkml.org/lkml/2007/5/24/275
Submitter  : Ioan Ionita <opslynx@gmail.com>
Status     : Unknown



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"


