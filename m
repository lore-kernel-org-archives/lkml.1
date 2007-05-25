Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbXEYGeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbXEYGeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 02:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbXEYGdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 02:33:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:27856 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbXEYGdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 02:33:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iyB8AGwg4AQSIw5ls4AbPqAttY8rsuPcgL4NSvGzsgMJblGaefy3pw4IKGqNp9SJ55H0hLh5R5Y5HxiBvUDOWSwqWHu2kPeMzVWBBh38dS7rZdk4/LRN/XO3lLUNb5CuruMtYSYeaC9zRj/cR8gEL0MfNNJUxyyKBNQUHAziKl4=
Message-ID: <d45a3acc0705242333v1f4c65d4x92b0167d51e3b1a6@mail.gmail.com>
Date: Fri, 25 May 2007 16:33:51 +1000
From: "andrew hendry" <andrew.hendry@gmail.com>
To: coly <colyli@gmail.com>
Subject: Re: it seems Evolution remove the Tabs
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "WANG Cong" <xiyou.wangcong@gmail.com>,
       "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>,
       linux-ext4 <linux-ext4@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1180073061.4136.3.camel@coly-t43.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179943606.4179.53.camel@coly-t43.site>
	 <1180012837.11124.11.camel@kleikamp.austin.ibm.com>
	 <1180018046.4078.2.camel@coly-t43.site>
	 <Pine.LNX.4.61.0705241826070.31549@yvahk01.tjqt.qr>
	 <20070525013003.GA2429@localhost.localdomain>
	 <Pine.LNX.4.61.0705250745390.14357@yvahk01.tjqt.qr>
	 <1180073061.4136.3.camel@coly-t43.site>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

select your whole mail and use pre-format in evolution.
or change it to pre-format and do insert->text file.
this should send it with tabs intact, the confusing bit i think is if
your testing it by sending it to yourself, then you cant see the tabs
again.

Read it in another mailer, something like sylpheed or mutt to see if
the tabs are really there.

On 5/25/07, coly <colyli@gmail.com> wrote:
> Hi,
>
> I tested again, it seems Evolution removes the Tabs with blanks.
> How to resolve this issue on Evolution ?  I am trying :-)
>
> Coly
>
> 在 2007-05-25五的 07:52 +0200，Jan Engelhardt写道：
> > On May 25 2007 09:30, WANG Cong wrote:
> > >>>
> > >>>Yes, I found all TABs gone when I received the mail. When I post next
> > >>>version of the patch, I will test to send to me first :-)
> > >>>
> > >>>Thanks for your information.
> > >>
> > >>Blame Gmail.
> > >
> > >I am using gmail too. That's not gmail's fault,
> >
> > Then it is one of these:
> > - gmail's default settings for web input sucks or
> >
> > - the web browser reformats it
> >   (not so much - pastebin.ca suffers from something similar, but *not the
> >   same*; in that it translates all tabs into spaces, but at least it keeps
> >   the width.) or
> >
> > - you are using your own client, and directly SMTPing gmail servers,
> >   in which case unwanted reformatting by broken MTAs can be bypassed.
> >
> > >I think your email client sucks.
> > >So which email client are you using, coly? I recommend mutt to you. ;)
> >
> > X-Mailer:      Evolution 2.6.0
> >
> > Hm, this looks like another of these "Thunderbird" cases. (Means,
> > Thunderbird users also get their patches wrapped and twangled unless
> > they set some option that is not on by default.)
> >
> >
> >       Jan
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
