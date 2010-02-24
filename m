Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab0BXBNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 20:13:36 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60886 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0BXBNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 20:13:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oMPDS7Yso3V22TQuX2NsIKYu8R8S9cu3mnp5R4x/4g31rHNiW3QQAI4YLsDL3f0FGP
         9aSF8L65NjNBWl2PKXNoxvJjb3gh0+g9JN7J3g9BE6FLa0fnNOJPZDMvv1QjzH7TVwml
         0JS4GDqizQQT+hlJzni4xCVDTVEbentgKWIMc=
MIME-Version: 1.0
In-Reply-To: <6599ad831002231645g7a53f7bbkda4c7d3cfad2d71@mail.gmail.com>
References: <1266838378.3962.10.camel@centos51>
	 <6599ad831002231645g7a53f7bbkda4c7d3cfad2d71@mail.gmail.com>
Date: Wed, 24 Feb 2010 10:13:34 +0900
Message-ID: <49b7c2351002231713h1b8bfeafp6d7b829180894f72@mail.gmail.com>
Subject: Re: [PATCH] cpuset: Update the cpuset flag file from old name from 
	new name correctly.
From: GeunSik Lim <leemgs1@gmail.com>
To: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 9:45 AM, Paul Menage <menage@google.com> wrote:
> On Mon, Feb 22, 2010 at 3:32 AM, GeunSik Lim <leemgs1@gmail.com> wrote:
> Looks reasonable, thanks.
>
> There are some bits in the docs where the "cpuset." prefix isn't
> really needed, but I guess it's better to be consistent.
>
> Acked-by: Paul Menage <menage@google.com>
Thank you for reviews about this patch. :)


-- 
Regards,
GeunSik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
