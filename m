Return-Path: <linux-kernel-owner+w=401wt.eu-S933084AbXDZGs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbXDZGs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933089AbXDZGs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:48:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:60196 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084AbXDZGs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:48:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aLuCgxjrJzK8hmtHxAMneEeERJIE+HD8NsXg9R9FA3dGKYAWxY7aFP5IbhCchw/hWvyTtSlst3UdvT5PKzzxUN75tZsYrBEcFr8e5KRuy+dFETfLlS+uklb871/oyyBpoQoYiZ1IUWIJPQX9valB1+I9xQsqfVK00gZpaCTWrvE=
Message-ID: <b6a2187b0704252348t1242560dqad6a1d30e665abc5@mail.gmail.com>
Date: Thu, 26 Apr 2007 14:48:25 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "lkml777@123mail.org" <lkml777@123mail.org>
Subject: Re: Question about Reiser4
Cc: linux-kernel@vger.kernel.org, "Eric Hopper" <hopper@omnifarious.org>,
       "William Heimbigner" <icxcnika@mar.tar.cc>,
       "Alex Zarochentsev" <zam@namesys.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Rik van Riel" <riel@redhat.com>,
       "Edward Shishkin" <edward@namesys.com>
In-Reply-To: <1177564182.15467.1186637743@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070423111939.c876c9cc.akpm@linux-foundation.org>
	 <462E17AF.7090604@namesys.com>
	 <20070424193921.GA17129@one.firstfloor.org>
	 <462F6717.70508@namesys.com>
	 <b6a2187b0704250749s2a00dadep93b2943bc0b9df9d@mail.gmail.com>
	 <1177564182.15467.1186637743@webmail.messagingengine.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/07, lkml777@123mail.org <lkml777@123mail.org> wrote:
>
> On Wed, 25 Apr 2007 22:49:11 +0800, "Jeff Chua"
> <jeff.chua.linux@gmail.com> said:
> >
> > Reiser4 has great potential and I'll be more than happy to test it.
> >
> Yeah,... let us know the details of your testing.

Ok, got reiser4 running on 1 full 250GB partition on Linux-2.6.21-rc7,
and up running reiser4 on another 2 systems. Have done a lot copy and
have not run into an problem since last night.

I'll try it with 2.6.21 soon.

What would be nice is to get grub2 to boot up on the reiser4
partition. I've seen patch for grub, but not for grub2.

I planning to deploy this for squid caching soon.

Thanks,
Jeff.
