Return-Path: <linux-kernel-owner+w=401wt.eu-S932745AbXBVIiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbXBVIiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932786AbXBVIiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:38:25 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:38210 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745AbXBVIiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:38:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eyQqoIuDssNb6bhc3cBOfcqyClJwzvohbzxa6cO32Xn/jHC6ULxGf6bDgJDsvEtDkmJEgcdlOFIheCUHoRxpiByyJuWvsRDNai5tegwNsT1+DlqhDyMecCqeav6dg4n4eglhRoo41aLOxxTeaJXt/Z60j+T4xx9qFdEbA6YJfrM=
Message-ID: <8d158e1f0702220038h6101ab50h4ae57aa4ed0684a7@mail.gmail.com>
Date: Thu, 22 Feb 2007 09:38:23 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: rol@as2917.net
Subject: Re: libsata doesn't like bus without master
Cc: "Vincent Legoll" <vincent.legoll@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <033401c75659$251d8c40$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702211301n3d30f590t14b1501e418da7e0@mail.gmail.com>
	 <033401c75659$251d8c40$4b00a8c0@donald>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/07, Paul Rolland <rol@as2917.net> wrote:
> Hello,


> <please no flame war>
>
I dont think there is one or that this reply of yours could cause it :P

> Just to add my $0.02 on this point : this could also be one of the problem
> I'm facing on my machine right now, but the point is that Windows supports
> it perfectly. At least that proves it can work, and it does work.

If I read the posts correctly it was allready established that the
drivers in Linux should support this but yes, I do agree with you,
whatever a BIOS supports should be supported by the kernel as well in
my opinion. And, at least the BIOSes and drives I used, support single
slave operations, how stupid this might be :)

Anyways, today is my first day at work again after a fever, so I will
be messing with stuff and hardware again, and will try to do some more
tests/breakage hoorah.

Patrick
