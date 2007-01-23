Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXAWNi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXAWNi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 08:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965085AbXAWNi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 08:38:59 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:24235 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965068AbXAWNi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 08:38:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Gw9yPDAJQ+i3qrrYNaEwhenP6bY2Z87T7aUyRTKz0glNth/M2d9cbfj7z4RSv1dHmWUGuJYzVuXo/lRDCwkZG+K/uIWLTLVSF2ohYL8HHPld0mip1yJisbihoNCpm3qP1G1GgBbxlqLtRJuyisi/DQBSaB2sARty9x6i7GIBZE0=
Message-ID: <8355959a0701230538m2f1201b6u49853e65d4c69a57@mail.gmail.com>
Date: Tue, 23 Jan 2007 19:08:56 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Proposal] 2.6.18-stable release plans?
Cc: "Chuck Ebbert" <cebbert@redhat.com>, "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Chris Wright" <chrisw@sous-sol.org>
In-Reply-To: <9a8748490701221623q1b61f03fva7b0ad7e7f30316f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45B53722.9030206@redhat.com>
	 <9a8748490701221623q1b61f03fva7b0ad7e7f30316f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
>
> Now that 2.6.19 is out, most likely not.  -stable releases are made
> for the latest stable 2.6.x kernel, once 2.6.x+1 is out that's the one
> -stable patches are made for (2.6.16 is an exception)..

Earlier I was going through the stable paches which apply for these
kernel version:

http://kernelnewbies.org/Linux_2_6_19
http://kernelnewbies.org/Linux_2_6_18
http://kernelnewbies.org/Linux_2_6_16

I have to dig deep into the patch & kernel version to understand what
are the features/implementations or fixes (patch).  Problem here is 2
ways:-

1) Identifying which is a better kernel (features) for
Desktop/Embedded/Server (I know, info mentioned in Changelog. But
still...)

2) Easily knowing which stable patch applies for which arch or sub
system (better way)

Proposal: Can maintainers implement this for better understanding of
the Linux community (picking the best kernel or patch for the
requirement) by adding a column on www.kernel.org home page?

Examples:

The latest stable version of the Linux kernel is:  	2.6.19.2
*networking subsystem*	2007-01-10 19:11 UTC 	F 	V 	VI 	C 	Changelog

The latest prepatch for the stable Linux kernel tree is:  	2.6.20-rc5
*x86 32/64*	2007-01-12 19:29 UTC 	B 	V 	VI 	C 	Changelog

> --
> Jesper Juhl <jesper.juhl@gmail.com>

Thanks,

Akula2
