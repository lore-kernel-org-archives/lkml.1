Return-Path: <linux-kernel-owner+w=401wt.eu-S935482AbXG0UD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935482AbXG0UD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932886AbXG0UDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:03:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:25196 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542AbXG0UDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:03:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VYb7i58/Q1Jg005DW14QFxOvtKUhbrFhX6EKaLWiH5H/HJU7Z0dZgCeBZDcbN85eNo2A6x1mDJgwxOvnItBtqB1X2R9ope2xsV8uY7oHwxgOSjYFnjANaYXRi6Slpb9n5L2JM9WhmKMLT1bGIaKUZRkZMTxInmdJFA5zhhHbuE0=
Message-ID: <9a8748490707271303h7f5187ffk31d211c34fd885bf@mail.gmail.com>
Date: Fri, 27 Jul 2007 22:03:16 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: shacky <shacky83@gmail.com>
Subject: Re: Kernel modules compilation
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <7fedbc910707271211v2ac2c927k3dd8fec8643ee250@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7fedbc910707271211v2ac2c927k3dd8fec8643ee250@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/07/07, shacky <shacky83@gmail.com> wrote:
> Hi.
>
> During the Linux kernel compilation, I need to compile some modules
> which are necessary for the system boot.
> I localized these modules analyzing the modules which are
> automatically loaded at the startup of my Debian system whith the
> standard Debian kernel, through the output of the "lsmod" command.
> I tried to search for these modules in the "menuconfig" kernel
> configuration program, but I cannot find some of them, not even
> searching in the .config file.
>
> How I can find what items in "menuconfig" I need to activate (marking
> it with "m") to compile the modules I need for the system startup?
>
You could start by telling people what modules you are talking about.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
