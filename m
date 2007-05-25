Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbXEYGmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbXEYGmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 02:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbXEYGm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 02:42:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:20144 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbXEYGmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 02:42:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LsNHMksWFC2tBHLAsi7XGTo+qcqwyctcY6vnX8xa907XvU0emutkwEIretxaAURO8hgoCDjKFnj+NSj3lPPhG5u7A6ElxbZlVvjKZqCBtq9IsrnHyfNBpWDACa6ITYiibbS7+l2b72OA5xLFwY9ZB7U+ly3P0/0j/4LOnodnl8c=
Subject: Re: it seems Evolution remove the Tabs
From: coly <colyli@gmail.com>
To: andrew hendry <andrew.hendry@gmail.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       linux-ext4 <linux-ext4@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <d45a3acc0705242333v1f4c65d4x92b0167d51e3b1a6@mail.gmail.com>
References: <1179943606.4179.53.camel@coly-t43.site>
	 <1180012837.11124.11.camel@kleikamp.austin.ibm.com>
	 <1180018046.4078.2.camel@coly-t43.site>
	 <Pine.LNX.4.61.0705241826070.31549@yvahk01.tjqt.qr>
	 <20070525013003.GA2429@localhost.localdomain>
	 <Pine.LNX.4.61.0705250745390.14357@yvahk01.tjqt.qr>
	 <1180073061.4136.3.camel@coly-t43.site>
	 <d45a3acc0705242333v1f4c65d4x92b0167d51e3b1a6@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 25 May 2007 14:42:21 +0800
Message-Id: <1180075342.4136.4.camel@coly-t43.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Thanks for your information :-)

Coly


在 2007-05-25五的 16:33 +1000，andrew hendry写道：
> select your whole mail and use pre-format in evolution.
> or change it to pre-format and do insert->text file.
> this should send it with tabs intact, the confusing bit i think is if
> your testing it by sending it to yourself, then you cant see the tabs
> again.
> 
> Read it in another mailer, something like sylpheed or mutt to see if
> the tabs are really there.
> 
> On 5/25/07, coly <colyli@gmail.com> wrote:
> > Hi,
> >
> > I tested again, it seems Evolution removes the Tabs with blanks.
> > How to resolve this issue on Evolution ?  I am trying :-)
> >
> > Coly
> >
> > 在 2007-05-25五的 07:52 +0200，Jan Engelhardt写道：
> > > On May 25 2007 09:30, WANG Cong wrote:
> > > >>>
> > > >>>Yes, I found all TABs gone when I received the mail. When I post next
> > > >>>version of the patch, I will test to send to me first :-)
> > > >>>
> > > >>>Thanks for your information.
> > > >>
> > > >>Blame Gmail.
> > > >
> > > >I am using gmail too. That's not gmail's fault,
> > >
> > > Then it is one of these:
> > > - gmail's default settings for web input sucks or
> > >
> > > - the web browser reformats it
> > >   (not so much - pastebin.ca suffers from something similar, but *not the
> > >   same*; in that it translates all tabs into spaces, but at least it keeps
> > >   the width.) or
> > >
> > > - you are using your own client, and directly SMTPing gmail servers,
> > >   in which case unwanted reformatting by broken MTAs can be bypassed.
> > >
> > > >I think your email client sucks.
> > > >So which email client are you using, coly? I recommend mutt to you. ;)
> > >
> > > X-Mailer:      Evolution 2.6.0
> > >
> > > Hm, this looks like another of these "Thunderbird" cases. (Means,
> > > Thunderbird users also get their patches wrapped and twangled unless
> > > they set some option that is not on by default.)
> > >
> > >
> > >       Jan
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >

