Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbYAXVfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbYAXVfz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbYAXVfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:35:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:20819 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbYAXVfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:35:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=efC6gEwgE0Cj62hzqcdK2Q0rRbUCqB6/eyBo9i1PtU3m1fRYObvAoNYMNuCntzhR5iZgldV95XAvgpHkH8xmeXjMoGzhIPvj9e7Glt9QS8rdI5ZxUWJbvTWVdJx8DBYLSYtCHRx8NSFfvYIemOjNNqkbsiXMchIC5L4YUTGaeXk=
Message-ID: <6101e8c40801241335y62b85de7kc26f2a41e4d44216@mail.gmail.com>
Date: Thu, 24 Jan 2008 22:35:43 +0100
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
In-Reply-To: <4798FF52.30801@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40801210959v1e0f6e55w26187dc93a09a202@mail.gmail.com>
	 <4798C817.6020702@goop.org>
	 <6101e8c40801241033m7347ec5fof8e41c3fe7974feb@mail.gmail.com>
	 <4798E26D.6010908@goop.org>
	 <6101e8c40801241228m6026b91bnfcf29c2da3944dfa@mail.gmail.com>
	 <4798FF52.30801@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks

On 1/24/08, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Oliver Pinter (Pintér Olivér) wrote:
> > the original topic name is : why linux kernel crap ...
> >
> > the substance is, when from kernel call users-pace program, then come
> > up more problems with security...
> > when the fs crash out or the userspace code is breaked, then the
> > system not shuting down ..
> >
>
> orderly_poweroff() has the option to force a hard shutdown if the exec
> of the usermode command fails.
>
>     J
>


-- 
Thanks,
Oliver
