Return-Path: <linux-kernel-owner+w=401wt.eu-S1759361AbYBWQ2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361AbYBWQ2g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 11:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYBWQ22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 11:28:28 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:52458 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbYBWQ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 11:28:27 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Sat, 23 Feb 2008 17:27:54 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Alexey Zaytsev <zaytsev.a@protei.ru>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
References: <47BEAF3B.3080809@protei.ru> <200802221848.37902.mb@bu3sch.de> <20080223110751.GN23833@elte.hu>
In-Reply-To: <20080223110751.GN23833@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802231727.54351.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2008 12:07:51 Ingo Molnar wrote:
> I have to say, after having observed multiple incidents around b43 in 
> the past few months you are one of the worst driver maintainers i've 
> ever seen on lkml: you are ignoring regressions, you are frequently 
> insulting our testers and now you even have the gall to NAK a patch to 

The insults being? A few quotes, please.

> _your own buggy driver code_ without providing an alternative fix. 
> Kudos.

How dare can you break my kernel, yeah... . We know that.
That my patches _fixed_ the kernel for thousands of people doesn't
matter. What matters is the one person for whom it broke. So let's
apply a questionable fix for it that we don't understand. Hopefully
that fixes it and doesn't break it again for somebody else... .

I provided an alternative fix. In my very first email.
Ingo, if you know that this fix is right, then please sign it off
so we can apply it.

-- 
Greetings Michael.
