Return-Path: <linux-kernel-owner+w=401wt.eu-S965039AbXHZWQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965039AbXHZWQU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 18:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964785AbXHZWQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 18:16:13 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:15656 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964776AbXHZWQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 18:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=te+5i3BYbQ5NFoQO5h2IhE6ucOpzZ2/w0HSY/zVNtcVhTjVBI9n7YcxAKusjhuXgg/mK57CPVyg1JdI2eN5i5rJ5+UxXOD3WvFdRKVq3DL+Pv3WO4Gr1hoDh2mH7JyqHtdcZfVJN2GVsF83xclrHWZBtYICMYU7yjDMMa9aLYi8=
Message-ID: <9a8748490708261516u65304f0an32fce22a3d0a36f4@mail.gmail.com>
Date: Mon, 27 Aug 2007 00:16:10 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Fred Tyler" <fredty8@gmail.com>
Subject: Re: Slow, persistent memory leak in 2.6.20
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/07, Fred Tyler <fredty8@gmail.com> wrote:
> I think I've come across a memory leak in 2.6.20. I've upgraded to the
> latest 2.6.20.17, but it didn't seem to help.
>
Have you tried the latest 2.6.22.5 ?
A lot of memory leaks have been fixed between 2.6.20 and the latest
stable kernel - could be that yours is amongst the ones fixed :-)


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
