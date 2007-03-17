Return-Path: <linux-kernel-owner+w=401wt.eu-S965540AbXCQN40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965540AbXCQN40 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 09:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965548AbXCQN40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 09:56:26 -0400
Received: from aeimail.aei.ca ([206.123.6.84]:51972 "EHLO aeimail.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965540AbXCQN4Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 09:56:25 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: RSDL v0.31
Date: Sat, 17 Mar 2007 09:56:13 -0400
User-Agent: KMail/1.9.5
Cc: Nicholas Miell <nmiell@comcast.net>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Ingo Molnar <mingo@elte.hu>,
       Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <1174110965.7911.44.camel@Homer.simpson.net> <1174111737.7911.50.camel@Homer.simpson.net>
In-Reply-To: <1174111737.7911.50.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200703170956.13901.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2007 02:08, Mike Galbraith wrote:
> P.S.  "utter failure" was too harsh.  What sticks in my craw is that the
> world has to adjust to fit this new scheduler.

If a new scheduler has a better 'normal' performance adjusting to its quirks
is fine.  Your testing is important.  We need to understand what needs
to be tweaked and why.  

>From my POV 0.30 is better than mainline - it handles my load(s) better.

Thanks
Ed Tomlinson
