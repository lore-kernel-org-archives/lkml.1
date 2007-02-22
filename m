Return-Path: <linux-kernel-owner+w=401wt.eu-S965025AbXBVA06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965025AbXBVA06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965045AbXBVA06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:26:58 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:41593 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965025AbXBVA04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:26:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tw1UYpNi1Uy7qK7RDWgkn94Q1+AgtDqjtx5eE1eRgBLcXhkngzfQNpALRGme8MoFhCQGqKlOaM4pMiLFB72KRDPkyVOD+y8tAcSvNhQYZRlYzlCCT8OnpwTW8ytytxXvxHsacjwx1CVt6BmNfFE0w+7J6MZYvzSauqEUlYP1Utk=
Message-ID: <f2b55d220702211626r2b8c4940i1c9ad6087a5bbe6c@mail.gmail.com>
Date: Wed, 21 Feb 2007 16:26:55 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Nuno Silva" <nuno.silva@vgertech.com>
Subject: Re: GPL vs non-GPL device drivers
Cc: davids@webmaster.com, "v j" <vj.linux@gmail.com>,
       trent.waddington@gmail.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Neil Brown" <neilb@suse.de>
In-Reply-To: <45DCD61B.7000804@vgertech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com>
	 <MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com>
	 <f2b55d220702211408r7954d5dar2c59e1e679316811@mail.gmail.com>
	 <45DCD61B.7000804@vgertech.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Nuno Silva <nuno.silva@vgertech.com> wrote:
> I can see that your argument is all about the defenition of a
> "derivative work".

Far from it.  Try reading to the end.

> We all know that #include <anything.h> is mostly non copyrightable, so I
> mostly agree that some - very very simple - modules may not need to
> include the source when distributing the resulting module.ko. (need =
> from a legal standpoint... The intended spirit of the GPL is another story)

The "intended spirit of the GPL" is very different from what you think
it is, as $674 million of Red Hat stock can testify.  It is also
utterly irrelevant except when the circumstances surrounding someone's
acceptance of the GPL indicate that the two parties negotiated more or
less directly before settling on its terms.

> In this context what do you think about porting Linux to another arch?
> Does the people porting the OS needs to distribute the source with the
> [compiled] kernel?

Of course.  They're distributing a derivative work of the kernel, or
perhaps even (for legal purposes) distributing Linus's work of
authorship with trivial editorial changes that do not create a new
copyrightable work.  They need license to do so, and the only license
on offer is GPL v2, which conditions the license on distribution of
source code.

Cheers,
- Michael
