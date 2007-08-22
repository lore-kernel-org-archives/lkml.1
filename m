Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbXHVKHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbXHVKHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbXHVKGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:06:54 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:31457 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbXHVKGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:06:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iDW2T0Tma2ORgujw5C0Vl5xcXRKktjLddBdKsuasgvS0PqVmlldBRPyTf1XMozc76oukoyz3pl+hBCpt9Zncijhpd20VU0N7gCLZ6XAwDgtKUuLeOQwqg2eu+tKapRToyxwg4FYvn0/mNBwb4vRdypjj2KF8MgOTnVOE3LGkshk=
Message-ID: <9a8748490708220306t46ed1c34m554a8df47c0794ce@mail.gmail.com>
Date: Wed, 22 Aug 2007 12:06:52 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Noud Aldenhoven" <jwaixs@gmail.com>
Subject: Re: How to learn Linux Kernel Programming
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <cb63d1e10708212347y251a34fah739c4b42ab49609e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cb63d1e10708211228u383240a2l4af811f72b8858c0@mail.gmail.com>
	 <cb63d1e10708211229n18cc154ep43912a671ca1bfee@mail.gmail.com>
	 <5d6222a80708212015w260a2fcdr64227eb740b8d933@mail.gmail.com>
	 <cb63d1e10708212346l746111dcic584b4bb5fe461fc@mail.gmail.com>
	 <cb63d1e10708212347y251a34fah739c4b42ab49609e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(please don't trim Cc lists when replying, just use Reply-to-all)

On 22/08/07, Noud Aldenhoven <jwaixs@gmail.com> wrote:
> Thank you for your information and help,
>
> I think it's a lot more clear for me now.
> I've seen the ldd3 some time ago, but someone told me that book was
> out-of-date. Guess he was wrong.

It /is/ out of date, but it still contains a lot of useful information.

> Would it also be use full to use some
> kind of cross-compiler? (don't know if that's the right word for it)
> So I can run my stable kernel and on top of it a new experimental
> kernel where I can experiment with?
>
A cross compiler is used to compile a kernel for one architecture
while running a different one. for example; building a kernel to run
on ppc64 while running i386.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
