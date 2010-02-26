Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935437Ab0BZHdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 02:33:24 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:39873 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935430Ab0BZHdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 02:33:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cd+596dlu4jgoMx9zk2xwK79QkbguF28HyhXd/Of2D71H6garxnTOyFj5N4648wzCs
         9JsSCfHA/s5jLXy01BZfhk2ahL61ps05gQnVjLg6fnLquYVQ8vOgt9wjIriW/D4tAhKe
         DD10fkk9ssc99mJ+SiS+h3OjwLyLfo8CZj/gE=
MIME-Version: 1.0
In-Reply-To: <b6fcc0a1002252315k1fd5360ehf5ea33566c19515d@mail.gmail.com>
References: <20100225155359.GA2722@darkstar> <20100225185515.GB3305@core2>
	 <a8e1da1002251714l55ccbd44ibc1119770667c62b@mail.gmail.com>
	 <b6fcc0a1002252315k1fd5360ehf5ea33566c19515d@mail.gmail.com>
Date: Fri, 26 Feb 2010 15:33:20 +0800
Message-ID: <a8e1da1002252333g6e8bf94crba465c59c0cbc07a@mail.gmail.com>
Subject: Re: [PATCH 03/07] kernel.h string cleanup
From: Dave Young <hidave.darkstar@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 3:15 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Fri, Feb 26, 2010 at 3:14 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> Yeah, same question, then where should they go?
>
> Should I hand a patch to you, so you can repost it?

Please, if you think spliting is not necessary, you can just say that,
or feel free to send a patch.

>
>> I think string.h is fine.
>
> It obviously isn't fine.
>
> Why all of sudden kernel.h split when kernel.h is for simple misc stuff
> for which there is no other place.
>

It will be better to move some of them to proper place instead of kernel.h

-- 
Regards
dave
