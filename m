Return-Path: <linux-kernel-owner+w=401wt.eu-S932201AbXBNLNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbXBNLNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 06:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbXBNLNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 06:13:55 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:44710 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbXBNLNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 06:13:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QfoI50hzehfy9ZvqUD7+3L2zeA9GIBD0WOA5fP0txOSRCXrZbV/prm/XJoriErt910IRfGYFVlZqgg42so+UjqJcQ9Jb2uprkfkrEFz/DbN27UY9H5yD5+YEP0rcGAu/jAoZxG/5ItWlCk5PUsXZRfraP9iv176gmz1Nn1DL7Ho=
Message-ID: <5a4c581d0702140313q6d048eufa83d7b3d058311@mail.gmail.com>
Date: Wed, 14 Feb 2007 12:13:52 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Andreas Gruenbacher" <agruen@suse.de>
Subject: Re: Bug in current -git tree causing dbus and gnome to chew up cpu time
Cc: "Greg KH" <greg@kroah.com>, torvalds@linux-foundation.org, neilb@suse.de,
       viro@zeniv.linux.org.uk, hch@lst.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200702140157.59252.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070213195116.GA5181@kroah.com>
	 <5a4c581d0702140147s7931bd63ief299780fa6963a5@mail.gmail.com>
	 <200702140157.59252.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/14/07, Andreas Gruenbacher <agruen@suse.de> wrote:
> Hi,
>
> I've described the problem and possible fixes in the "Re: [PATCH] Fix d_path
> for lazy unmounts" thread, Message-Id: 200702140019.36378.agruen@suse.de.

Yes, I saw that. But there isn't any patch for me to test, and my
 userspace remains broken. Please don't get me wrong - I'm
 not bitching about this, but I will effectively not be able to test
 newer snapshots until either a fix for this new bug gets in, or
 the commit that introduced the bug gets reverted.

Thanks,

--alessandro

 "but I thought that I should let you know
  the things that I don't always show
  might not be worth the time it took"

     (Steve Wynn, 'If My Life Was An Open Book')
