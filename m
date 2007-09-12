Return-Path: <linux-kernel-owner+w=401wt.eu-S1758231AbXILFLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231AbXILFLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 01:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbXILFLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 01:11:17 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:25275 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbXILFLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 01:11:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=dGMccIC4CJlOuoann9FaVm3epN7NqkFubYiNpKKdTpjWaL4xiouEbwagCVIj/RC53Hpi8OmvY7r2CglDHzL4iA9P5jp7q9WzgUz/WStQU82LVbTv/tZFu9QuxuyEt5cA7qNCw6uBgye5x9a8xjCSVp/M22jK0kYXKiG3MuHCiYk=
Date: Wed, 12 Sep 2007 13:07:51 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lee Revell <rlrevell@joe-job.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       jgarzik <jgarzik@pobox.com>
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
Message-ID: <20070912050751.GG2579@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com> <1189532202.21778.84.camel@twins> <75b66ecd0709111138xb5f6120qee40345378b188eb@mail.gmail.com> <1189536734.5739.2.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189536734.5739.2.camel@lappy>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 08:52:14PM +0200, Peter Zijlstra wrote:
>
>On Tue, 2007-09-11 at 14:38 -0400, Lee Revell wrote:
>> On 9/11/07, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Tue, 2007-09-11 at 10:16 -0700, Randy Dunlap wrote:
>> >
>> > > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> > > +Evolutions (GUI)
>> >
>> > I take it you mean: Evolution
>> >
>> > > +Some people seem to use this successfully for patches.
>> > > +
>> > > +What config options are needed?
>> >
>> > When composing mail select: Preformat
>> >   from Format->Heading->Preformatted (Ctrl-7)
>> >   or the toolbar
>> >
>> > Then use:
>> >   Insert->Text File... (Alt-n x)
>> >
>> > to insert the patch.
>> 
>> You can also diff -Nru old.c new.c | xclip, select Preformat, then
>> paste with the middle button.
>
>Ah, I shall try:
>
>  cat `quilt top` | xclip
>
>next time I have a single patch to send.
>

Oh, great! Thank you for this hint.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

