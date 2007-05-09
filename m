Return-Path: <linux-kernel-owner+w=401wt.eu-S968960AbXEIEwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968960AbXEIEwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 00:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbXEIEwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 00:52:16 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:16330 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbXEIEwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 00:52:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M2epAzy2g6Mys/h/YabNVHGjMye4l2YQuHcRq3C36wZYGzXncFkQPLwEHhxEAkgQOBB/fvLGiQ75eT0CQ/WwPkp8Qdfpk7F1YRQpeRUWVd+VxNy4PrGmSamra54YIkWPwVIcOC6HxnbxZkWuCvubtx2s52BIEr8ogDPIoqcSTsk=
Message-ID: <86802c440705082152g49d4d3echf3eb165ce4feb2e9@mail.gmail.com>
Date: Tue, 8 May 2007 21:52:14 -0700
From: yhlu <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       vgoyal@in.ibm.com, "Gerd Hoffmann" <kraxel@redhat.com>,
       "Jeff Garzik" <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <m1tzumu10k.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4634483E.9030307@goop.org>
	 <m1k5vji107.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705081500x682ee098y7d51f7bb98dbcff6@mail.gmail.com>
	 <4640F4B3.30408@goop.org> <4640FB2C.2060300@zytor.com>
	 <86802c440705081541v7d0773cek2c5fae1854b68bbc@mail.gmail.com>
	 <46410403.4050802@zytor.com>
	 <m17irivkhy.fsf@ebiederm.dsl.xmission.com>
	 <46413087.2020505@zytor.com>
	 <m1tzumu10k.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Since the whole point is to detect the case where we don't have
> a screen at all it makes sense to check several additional variables
> and make certain that they are all 0.  Agreed?

need one good way to find if there is support vga console.

YH
