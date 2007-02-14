Return-Path: <linux-kernel-owner+w=401wt.eu-S932324AbXBNOgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbXBNOgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 09:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932323AbXBNOgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 09:36:11 -0500
Received: from qb-out-0506.google.com ([72.14.204.230]:7972 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbXBNOgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 09:36:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qnvg0L+HGrDIiSlRdsbkztwup6qMydFott4Lr4D3bVmOm6ZLXZLHfF185GmYjVaTor6QCK5a7B3qp7P+ark8RAmSYvjmJNH5ev4k0HVtImkF9XYsJiwgNxi5FlJyML8bKcgJlD6QUCmkSIGn/+TuLzZpH1k1Q93si7hZUKGanxg=
Message-ID: <9a8748490702140636w4ed2edb9md3cb9013823ba625@mail.gmail.com>
Date: Wed, 14 Feb 2007 15:36:07 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "RIz Khan" <holysinn3r@yahoo.co.uk>
Subject: Re: [KJ] Basics of linux kernel development.
Cc: kernel-janitors@lists.osdl.org, greg@kroah.com, kpm@linux-foundation.org,
       gregkh@suse.de, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070214141020.81403.qmail@web28102.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070214141020.81403.qmail@web28102.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/07, RIz Khan <holysinn3r@yahoo.co.uk> wrote:
>
> Dear Sir/Madam,
> I have an interview at symantec and i need to knw about Linux kernel
> development using C. I have done prgramming in C++ but in windows enviorment
> but i dont kknw nothing about linux and especially about kernel development.
> I would be greatfull if u can tell me something about it and recomend me a
> vry vry basic book.

So you want to learn a new programming language (C), a new operating
system (Linux) and dive into kernel development as well, all at the
same time - that's no small task :)

As for the C language bit, starting with K&R's "The C programming
language, second edition" is not a bad place to start.
http://www.amazon.co.uk/C-Programming-Language-2nd/dp/0131103628/sr=8-1/qid=1171463251/ref=pd_ka_1/203-7856448-7676754?ie=UTF8&s=books

As for the linux kernel, "Linux Kernel Development, second edition"by
Robert Love is a good introduction that gives a good overview of most
aspects of the kernel.
http://www.amazon.co.uk/Linux-Kernel-Development-Novell-Press/dp/0672327201/sr=1-1/qid=1171463315/ref=sr_1_1/203-7856448-7676754?ie=UTF8&s=books
You probably also want to read the file Documentation/HOWTO in the
Linux kernel source dir (as well as all the files it refers you to -
an online copy can be read here:
http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/HOWTO

And probably also won't hurt you to read "Linux in a Nutshell" by
Ellen Siever, Aaron Weber & Stephen Figgins if you want a good general
Linux reference.
http://www.amazon.co.uk/Linux-Nutshell-OReilly-Ellen-Siever/dp/0596009305/ref=pd_bxgy_b_img_b/203-7856448-7676754


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
