Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYHDWxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYHDWxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYHDWvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:51:47 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:16483 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYHDWvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s4EZkJIN4xk/j8FVoxCyaRR49mCl6CTAkExm9jMr8/s8zl95Ym3tD008/Vq+O9Xm4e
         AJJWx6MGs0Chu2MLlsFYMa26yhRGTAFJ3NIvHRkJCTonhtY9ZXsAnygS2KvU5lFa6TBJ
         c2NXwLtf4phkMMa3XiKXi8AVbS/othztf1dbs=
Message-ID: <43e72e890808041545y1b1727c1t90db35721a9c9d8d@mail.gmail.com>
Date: Mon, 4 Aug 2008 15:45:38 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: pull request: wireless-2.6 2008-08-04
Cc: "John W. Linville" <linville@tuxdriver.com>, davem@davemloft.net,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1217889426.7819.26.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080804193753.GA30345@tuxdriver.com>
	 <1217882288.7819.19.camel@californication>
	 <20080804204558.GA5866@tuxdriver.com>
	 <1217886123.7819.23.camel@californication>
	 <20080804215439.GA9658@tuxdriver.com>
	 <1217889426.7819.26.camel@californication>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 4, 2008 at 3:37 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi John,
>
>> > > > > Luis R. Rodriguez (4):
>> > > > >       list.h: Add list_splice_tail() and list_splice_tail_init()
>> > > > >       list.h: add list_cut_position()
>> > > >
>> > > > have these two changes got reviewed on LKML? I don't see any ACKs for it
>> > > > in the commit message.
>> > >
>> > > Hmmm...no.  I thought the original patches had been copied to
>> > > linux-kernel, but it looks like that is not the case.
>> > >
>> > > The original patches are archived here:
>> > >
>> > >   http://marc.info/?l=linux-wireless&m=121783421908441&w=2
>> > >
>> > >   http://marc.info/?l=linux-wireless&m=121783422008445&w=2
>> > >
>> > > What problems do you see with them?
>> >
>> > I don't see a problem with these patches, but they should at least be
>> > reviewed on LKML once. Changes to core kernel infrastructure should not
>> > be merged silently via subsystem trees without any kind of ACKs.
>>
>> Yes, fine.  That wasn't my intent. :-)  The patches were originally
>> posted about two weeks ago, too bad that didn't actually go to
>> linux-kernel. :-(
>
> just post them to LKML (or let Luis do it) so they get reviewed. I
> really don't see an issue with them, but that is only me.

I'll repost those specific patches and add lkml.

  Luis
