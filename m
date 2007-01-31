Return-Path: <linux-kernel-owner+w=401wt.eu-S932653AbXAaJUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbXAaJUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 04:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbXAaJUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 04:20:44 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:63036 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653AbXAaJUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 04:20:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XUDsCcxcssEzYUuBAJe+oAkO7mg9hDlh6aOIOWr8zNhN7wXjofTdb7HiAQ9j/bNUtnqDfPFHV9h6DRHMYPbs0J1wQ0eN9N0whcyy4UGlA7+4gHoHniWchtvw4NKpYhkEjt9RCwyMbXzy2eAzNjz/WmrmxZAZDgygpQ5ldSgmfbs=
Message-ID: <9a8748490701310120u54274d12gcaaa035bcc746fd9@mail.gmail.com>
Date: Wed, 31 Jan 2007 10:20:42 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: Rewriting floppy.c was Re: Free Linux Driver Development!
Cc: "Greg KH" <greg@kroah.com>, "Adrian Bunk" <bunk@stusta.de>,
       "Roland Dreier" <rdreier@cisco.com>, linux-kernel@vger.kernel.org
In-Reply-To: <p7364anpkz5.fsf_-_@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
	 <20070130191020.GF20642@kroah.com> <20070131011340.GP3754@stusta.de>
	 <20070131012428.GA31759@kroah.com> <p7364anpkz5.fsf_-_@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 Jan 2007 11:08:14 +0100, Andi Kleen <ak@suse.de> wrote:
> Greg KH <greg@kroah.com> writes:
> >
> > What?  Throw a fresh-faced newbie instantly into the tar-pit of despair
> > that floppy.c is?  Do you want everyone just to run screaming from
> > kernel development never to be seen again?
>
> Doing a from-scratch rewrite of floppy.c only supporting new
> hardware and no obscure formats ("newfloppy.c") would be an excellent
> newbie project imho.  This means for someone who is still pretty
> new, but wants to get their fingers wet with more complicated changes.
>
> Then over time (old-)floppy.c could be phased out.
>
> If anybody is interested...? (non newbies would be welcome too of course)
>
Sounds like a fun little project. I'll bite.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
