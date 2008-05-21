Return-Path: <linux-kernel-owner+w=401wt.eu-S937459AbYEUUhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937459AbYEUUhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936336AbYEUUhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:37:10 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:38484 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbYEUUhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:37:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XxEdloAvfXKzLTr/TTFAUHX4oXU1NFqoIdC4AbICQkabKve6/THhkvpLKiqGdN6SP1p2XU4gXboYV+SUyzFE8Zowy1HZXlN5mMe75JQUrl5CZrbsSWUi+LizYasPB5bX6upkCjulcweTsR8YPf+jtRssWhUIPYT7cmaaMobhpIE=
Message-ID: <9a8748490805211337q1e7ceab7i80e4820c46f8171b@mail.gmail.com>
Date: Wed, 21 May 2008 22:37:05 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jonathan Corbet" <corbet@lwn.net>
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard indentation of arguments)
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>, rdunlap@xenotime.net,
       tytso@mit.edu, hch@infradead.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <32279.1211401651@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490805211306l50b8411ax4462be18c94ca065@mail.gmail.com>
	 <32279.1211401651@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/21 Jonathan Corbet <corbet@lwn.net>:
> Jesper Juhl:
>
>> 2008/5/21 Andrew Morton <akpm@linux-foundation.org>:
>> > Yes, a general GettingStarted document would probably be useful.
>> > It would hopefully have more what-to-do content than what-not-to-do.
>>
>> I'm in the process of trying to write an initial draft of just such a
>> document right now. I'll post it once I'm a bit more done (gimme an
>> hour or two).
>
> In theory, that's Documentation/HOWTO.  In practice, quite a bit more is
> needed.

Documentation/HOWTO is indeed a very good place to start.

>I'm actually in the process of writing such a thing as well,
> with some support from the Linux Foundation.  I'll not have it done in
> an hour or two, though; a version for review in June is more likely...
>
What I'm doing right now is basically reformatting my own notes,
emails I've written on the subject, pieces of other documents I've
written etc etc and trying to put them in the shape of a Getting
Started document.  Perhaps getting that compiled into a reasonable
document in a few hours is a bit too optimistic, but I'll give it a
go, post what I have for review and we can take it from there.  :-)

I'd love to read your document once it's ready for review.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
