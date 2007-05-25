Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbXEYGDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbXEYGDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 02:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbXEYGDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 02:03:38 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:54914 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbXEYGDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 02:03:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OhFjujmflXFpjA/G6MCZijXSE/e4w6mtT5g4Hf28f0N8AQnw80s58kPhyKQA8FHC6l65/KkHTSah22yaZrTwxXNUScy+8cEIfilD/zZOISAWkdpNuxXXUTOsyHFANxFjdfUZKF7zI1lwvaaFPF3w6V7B6fVNB4IJeYGECcK0GR0=
Subject: it seems Evolution remove the Tabs
From: coly <colyli@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       linux-ext4 <linux-ext4@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705250745390.14357@yvahk01.tjqt.qr>
References: <1179943606.4179.53.camel@coly-t43.site>
	 <1180012837.11124.11.camel@kleikamp.austin.ibm.com>
	 <1180018046.4078.2.camel@coly-t43.site>
	 <Pine.LNX.4.61.0705241826070.31549@yvahk01.tjqt.qr>
	 <20070525013003.GA2429@localhost.localdomain>
	 <Pine.LNX.4.61.0705250745390.14357@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 May 2007 14:04:21 +0800
Message-Id: <1180073061.4136.3.camel@coly-t43.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tested again, it seems Evolution removes the Tabs with blanks.
How to resolve this issue on Evolution ?  I am trying :-)

Coly

在 2007-05-25五的 07:52 +0200，Jan Engelhardt写道：
> On May 25 2007 09:30, WANG Cong wrote:
> >>>
> >>>Yes, I found all TABs gone when I received the mail. When I post next
> >>>version of the patch, I will test to send to me first :-)
> >>>
> >>>Thanks for your information.
> >>
> >>Blame Gmail.
> >
> >I am using gmail too. That's not gmail's fault,
> 
> Then it is one of these:
> - gmail's default settings for web input sucks or
> 
> - the web browser reformats it
>   (not so much - pastebin.ca suffers from something similar, but *not the
>   same*; in that it translates all tabs into spaces, but at least it keeps
>   the width.) or
> 
> - you are using your own client, and directly SMTPing gmail servers,
>   in which case unwanted reformatting by broken MTAs can be bypassed.
> 
> >I think your email client sucks.
> >So which email client are you using, coly? I recommend mutt to you. ;)
> 
> X-Mailer:	 Evolution 2.6.0
> 
> Hm, this looks like another of these "Thunderbird" cases. (Means,
> Thunderbird users also get their patches wrapped and twangled unless
> they set some option that is not on by default.)
> 
> 
> 	Jan

