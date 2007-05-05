Return-Path: <linux-kernel-owner+w=401wt.eu-S933929AbXEEVwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929AbXEEVwd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933965AbXEEVwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:52:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:63445 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933929AbXEEVwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:52:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q6h4a4YOf2pkIBLRfEB+XbaimabV5qj6cCtRher7tciywpz3B3hj5pC87Fw/S/4TfMG7NacuOWeAsPMa0jj1pBy4x+mf3PB515o0jIAztbTy97JN78/xbl2WNArexL8zAQL26OJUnM47TlXJU1ZfMLwalKg8ggliSdcSl006FvU=
Message-ID: <9a8748490705051452rc47492elc78be0015ca81c35@mail.gmail.com>
Date: Sat, 5 May 2007 23:52:29 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Shahbaz Khan" <shaz.linux@gmail.com>
Subject: Re: lxr problem - newbie needs help
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20cbb9450705051345t16784d28k824c9a7c38891615@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20cbb9450705051345t16784d28k824c9a7c38891615@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/07, Shahbaz Khan <shaz.linux@gmail.com> wrote:
> I am using Fedora core 6. I have configured lxr 0.3 with the latest

I'm no expert on 'lxr', but as far as I can see version 0.3 is quite
old - according to http://sourceforge.net/projects/lxr - the latest
version is 0.9.4 - try upgrading to the latest version.

> glimpse but I get the following in the browser:
>
> -> Parent Directory
>   -  fileidx
>   -  xref
>
> when i click the files it gives me some wierd source code with lots of
> funny faces like ones in the ascii command line screens (if that makes
> sense at all!).
>
> lxr installprefix is /var/www/lxr/
> My document root for apache is /var/www/
> attached is my lxr configuration.
>
I think you'll have better luck with your query if you ask on one of
the lxr mailing lists, see http://sourceforge.net/mail/?group_id=27350
for details. The linux-kernel mailing list is for discussing technical
details of the Linux kernel itself, not for asking questions about
various other tools.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
