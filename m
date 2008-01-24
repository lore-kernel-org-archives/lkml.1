Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYAXSeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYAXSeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 13:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYAXSdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 13:33:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:6322 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYAXSdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:33:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RNK9lTxsZdYYE41g1Koz9EmY85nBlbb4DyaFK6ErWQrWEtoj3Uxo88GMvo6X6/dQf+Y911wRQ6cNtprzqE9S6ZFrBBappa3r5U6ipHBGEFhj3Z+6vQO2GHcfoLd9PG8bfgcGvUIsZvcSywZANe5q0Udu5m5R11w0odAcpSkizOA=
Message-ID: <6101e8c40801241033m7347ec5fof8e41c3fe7974feb@mail.gmail.com>
Date: Thu, 24 Jan 2008 19:33:52 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: Add common orderly_poweroff() to 2.6.22?
Cc: "Adrian Bunk" <bunk@kernel.org>, "David Miller" <davem@davemloft.net>,
       "Greg KH" <gregkh@suse.de>, "Greg KH" <greg@kroah.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>, "Arnd Bergmann" <arnd@arndb.de>
In-Reply-To: <4798C817.6020702@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40801210959v1e0f6e55w26187dc93a09a202@mail.gmail.com>
	 <4798C817.6020702@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/24/08, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Oliver Pinter (Pintér Olivér) wrote:
> > Hi all!
> >
> > commit in mainline 10a0a8d4e3f6bf2d077f94344441909abe670f5a is go in
> > the satble 2.6.22
> >
> > the grund for this question is http://hup.hu/node/49773 .
> >
>
> Is there a compelling reason?

no, but in forum some person have the question, why the kernel call
userspace program and it is secure or not...

 I added it to remove some duplicate code,
> but it isn't a bugfix or anything.
>
>     J
>
>

-- 
Thanks,
Oliver
