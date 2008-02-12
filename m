Return-Path: <linux-kernel-owner+w=401wt.eu-S1763533AbYBLQme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763533AbYBLQme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758314AbYBLQm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:42:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:22179 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763324AbYBLQmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:42:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QD9yVTtjTlLSBMxBmVIeQiqnAa7RsE+tVZD3IyMosr+DJZP7M90e+CMkF3F1uHj7bfFfGAw5v+dGJHnMHOqgsJ8vda7DERvdeQtivPuah0EEkxyyjkoya2EvX80sca0/whVJMzNfwo/ceErZ9nNjALqUOyPMiIgpuIRpAm/N2Qs=
Message-ID: <8499950a0802120842r638e60b4l44b45dc7ab67876b@mail.gmail.com>
Date: Tue, 12 Feb 2008 17:42:22 +0100
From: "Oleg Verych" <olecom@gmail.com>
To: "Mike Frysinger" <vapier@gentoo.org>
Subject: Re: [PATCH] kbuild: fix make V=1
Cc: "Oleg Verych" <olecom@flower.upol.cz>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <200802121118.11312.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org>
	 <200802121007.50638.vapier@gentoo.org>
	 <8499950a0802120749r33323a15k7cde80862ae26c3d@mail.gmail.com>
	 <200802121118.11312.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 12, 2008 5:18 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> On Tuesday 12 February 2008, Oleg Verych wrote:
[]
> > > i dont see how yours is more efficient when it always runs echo.
> >
> > Oh, this? It's like doing syscall for every write to "/dev/null".
>
> how is that relevant ?  there is no /dev/null redirection anywhere here

And here comes "no comments" part.
______
