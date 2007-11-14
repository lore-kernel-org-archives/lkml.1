Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbXKNJQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbXKNJQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 04:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbXKNJQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 04:16:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:16630 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbXKNJQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 04:16:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Cmd9Wr4UuphInSMBsWx19YUZsgVPYr7NgRzGOZRj7Crwa4o6j1ZI1rauMk4dPiqVG0I43D4aCjVKDEQiMadqttbhknO9GEJRgvcCk8d2EW6dpzPvGu26Rn5zt/cLqKQ/4AoE6IJDVhPgCZTzwvXufJix1joFFbe5b790+bMViOM=
Message-ID: <9a8748490711140116i126c47bdt3d2c76c3ce8eeeed@mail.gmail.com>
Date: Wed, 14 Nov 2007 10:16:16 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "WANG Cong" <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] Let 'make help' output info about includecheck
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, trivial@kernel.org,
       "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <20071114030127.GA2506@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200711120056.35359.jesper.juhl@gmail.com>
	 <20071114030127.GA2506@hacking>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/11/2007, WANG Cong <xiyou.wangcong@gmail.com> wrote:
> On Mon, Nov 12, 2007 at 12:56:35AM +0100, Jesper Juhl wrote:
> >From: Jesper Juhl <jesper.juhl@gmail.com>
> >
> >'make includecheck' is useful and we want people to run it, so
> >let 'make help' output information about its existence.
> >
> >
> >Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
>
> I think Randy Dunlap has done this[1]. ;)
>
> [1] http://lkml.org/lkml/2007/11/4/120
>

So it would seem.
I just looked in the latest git tree and noticed it was missing. I
didn't hunt for existing patches that fixed it.
Thank you for pointing it out.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
