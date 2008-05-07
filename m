Return-Path: <linux-kernel-owner+w=401wt.eu-S933590AbYEGTV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbYEGTV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933189AbYEGTUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:20:47 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:65443 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933166AbYEGTUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:20:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=llVzjBJb1I7waq8a+lgRATRwAkOEZMrsHoGKJx502BsZVapBHK0KBTJFbFqvaFbfHF2CpQ1K9zzjLbKDxNQ/G7d/Vebr5rIAnlEW2CwyUF4JO1tVwXGoQJudMseh+ZhvQMvjNBHaalDHGMd7muN4Zo7zZ8YG+Shmpy6QiCUgUw8=
Message-ID: <dd18b0c30805071220v7f486f79k6392d2c203b9326a@mail.gmail.com>
Date: Wed, 7 May 2008 19:20:44 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: nopage to fault
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <4821FFC0.5060907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30805071040i5e9c3d73uf60235b94dcce3c5@mail.gmail.com>
	 <4821F3EE.1010309@gmail.com>
	 <dd18b0c30805071207q1aaeb8daq7f63b02d3a58b5a@mail.gmail.com>
	 <4821FFC0.5060907@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 7:15 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 05/07/2008 09:07 PM, Justin Mattock wrote:
>
> > On Wed, May 7, 2008 at 6:24 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> >
> > > On 05/07/2008 07:40 PM, Justin Mattock wrote:
> > >
> > >
> > > > of the areas that I'm lost with is NOPAGE_SIGBUS for a return value.
> > > > in mm.h The only options I see is VM_FAULT_SIGBUS, VM_FAULT_ERROR. If
> > > >
> > > >
> > >  The former, next time, google little bit, please.
> > >
> > >
> >
> > Thanks for the help,
> >  you mean the former definition which was taken out "NOPAGE_SIGBUS",
> > or former as in an interface located somewhere in the kernel.
> > regards;
> >
>
>  The former constant you mentioned. I suppose you are asking what's the
> NOPAGE_SIGBUS opposite in fault handler, right?
>

I think what I'm trying to figure out is what would you put in
NOPAGE_SIGBUS's place since it no longer is in the kernel
Also I wouldn't mind knowing what the opposite fault handler would be as well.
regards;
-- 
Justin P. Mattock
