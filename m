Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbXEYF4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbXEYF4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXEYF4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:56:32 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:45084 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbXEYF4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:56:31 -0400
Date: Fri, 25 May 2007 07:52:35 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: WANG Cong <xiyou.wangcong@gmail.com>
cc: coly <colyli@gmail.com>, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       linux-ext4 <linux-ext4@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 2/5] inode reservation v0.1 (ext4 kernel patch)
In-Reply-To: <20070525013003.GA2429@localhost.localdomain>
Message-ID: <Pine.LNX.4.61.0705250745390.14357@yvahk01.tjqt.qr>
References: <1179943606.4179.53.camel@coly-t43.site>
 <1180012837.11124.11.camel@kleikamp.austin.ibm.com> <1180018046.4078.2.camel@coly-t43.site>
 <Pine.LNX.4.61.0705241826070.31549@yvahk01.tjqt.qr>
 <20070525013003.GA2429@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 25 2007 09:30, WANG Cong wrote:
>>>
>>>Yes, I found all TABs gone when I received the mail. When I post next
>>>version of the patch, I will test to send to me first :-)
>>>
>>>Thanks for your information.
>>
>>Blame Gmail.
>
>I am using gmail too. That's not gmail's fault,

Then it is one of these:
- gmail's default settings for web input sucks or

- the web browser reformats it
  (not so much - pastebin.ca suffers from something similar, but *not the
  same*; in that it translates all tabs into spaces, but at least it keeps
  the width.) or

- you are using your own client, and directly SMTPing gmail servers,
  in which case unwanted reformatting by broken MTAs can be bypassed.

>I think your email client sucks.
>So which email client are you using, coly? I recommend mutt to you. ;)

X-Mailer:	 Evolution 2.6.0

Hm, this looks like another of these "Thunderbird" cases. (Means,
Thunderbird users also get their patches wrapped and twangled unless
they set some option that is not on by default.)


	Jan
-- 
