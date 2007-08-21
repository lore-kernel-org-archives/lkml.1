Return-Path: <linux-kernel-owner+w=401wt.eu-S1757751AbXHUJ4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751AbXHUJ4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 05:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbXHUJ4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 05:56:34 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:42248 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbXHUJ4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 05:56:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RzTfrnX4mZ/utUAUPs14pNlThZ0zgGp7vE8KuMxL/eN5z6iV4UqApNGbAlaLsL/wnDF8pO/RZXT1N/KCqEd8vkDtoYlw2K84ec+a0wE98JawSqNzPm7a1yxzJiwfKrT02H4pocMbbjQKkHnjtq8uo2airNeA73KfgBzL5Ei5jlM=
Message-ID: <9a8748490708210256v31a0ca00oa0d83dc401aeb98f@mail.gmail.com>
Date: Tue, 21 Aug 2007 11:56:32 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Alexey Dobriyan" <adobriyan@sw.ru>
Subject: Re: [PATCH] ver_linux is [censored]
Cc: sam@ravnborg.org, akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070821071938.GA17761@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070821071938.GA17761@localhost.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/08/07, Alexey Dobriyan <adobriyan@sw.ru> wrote:
> Commit 4a645d5ea65baaa5736bcb566673bf4a351b2ad8 broke ver_linux
> on etch which glibc has 3-digit version number.

Whoops, sorry about that.

> Patch replaces awk
> wanking with more robust sed wanking.
>
> Tested on gentoo, etch, centos 4.2.
>
I tested your patch on Slackware 12.0, Debian 3.1 & Gentoo Base System
release 1.12.9 and it works fine on those as well.

> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Tested-by: Jesper Juhl <jesper.juhl@gmail.com>

> ---
>
>  scripts/ver_linux |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
