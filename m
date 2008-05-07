Return-Path: <linux-kernel-owner+w=401wt.eu-S933868AbYEGTkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868AbYEGTkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933182AbYEGTjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:39:46 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:14374 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726AbYEGTjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:39:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jZTiWcnd0RjTpD9Z/bvges/OYJ74e2pzxrqKgKGgDMFMUzhgdTxxkYsVGYMsX2NZ/bPPRZU85RtsiYiWxdx2l8VB2L1j7PemfiiaUV9hSUpLlTjI1qAitiHwUXDkq/FvaD5hamZRhgw22bOXMsUmvEsGa26h/x/jg4cM/0Vz5Ho=
Message-ID: <dd18b0c30805071239t6fc3fc29o730f0552fe1c7640@mail.gmail.com>
Date: Wed, 7 May 2008 19:39:42 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: nopage to fault
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <482201A8.90906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30805071040i5e9c3d73uf60235b94dcce3c5@mail.gmail.com>
	 <4821F3EE.1010309@gmail.com>
	 <dd18b0c30805071207q1aaeb8daq7f63b02d3a58b5a@mail.gmail.com>
	 <4821FFC0.5060907@gmail.com>
	 <dd18b0c30805071220v7f486f79k6392d2c203b9326a@mail.gmail.com>
	 <482201A8.90906@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 7:23 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 05/07/2008 09:20 PM, Justin Mattock wrote:
>
> > On Wed, May 7, 2008 at 7:15 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> >
> > > On 05/07/2008 09:07 PM, Justin Mattock wrote:
> > >
> > >
> > > > On Wed, May 7, 2008 at 6:24 PM, Jiri Slaby <jirislaby@gmail.com>
> wrote:
> > > >
> > > >
> > > > > On 05/07/2008 07:40 PM, Justin Mattock wrote:
> > > > >
> > > > >
> > > > >
> > > > > > of the areas that I'm lost with is NOPAGE_SIGBUS for a return
> value.
> > > > > > in mm.h The only options I see is VM_FAULT_SIGBUS, VM_FAULT_ERROR.
> If
> > > > > >
> > > > > >
> > > > > >
> > > > >  The former, next time, google little bit, please.
> > > > >
> > > >
> > >
> >
>
>
> >
> >
> > >  The former constant you mentioned.
> > >
> >
> >
> > I think what I'm trying to figure out is what would you put in
> > NOPAGE_SIGBUS's place since it no longer is in the kernel
> >
>
>  Well, the former from the 2 you mentioned in the very first post.
>


I would have to say VM_FAULT_SIGBUS
regards;

-- 
Justin P. Mattock
