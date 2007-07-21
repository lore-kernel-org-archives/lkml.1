Return-Path: <linux-kernel-owner+w=401wt.eu-S1765208AbXGUTVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765208AbXGUTVx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760302AbXGUTVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:21:46 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:50149 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760218AbXGUTVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:21:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AUKYa5usL6VbvGcZGTPuzTs+oYwShufeD027lR9VeMPjd9UxxeWbuqbR5YscaaGA6XqD67Qqpk8gCjg8h9iKLDHMk5NE7ZBaeBBYX3eVpxbMvKpWALF3OX/Z+d/P8cw+DvVj+3JvUIo/FmITf5J2QwXkamfi80JLc4y7VLS49+s=
Message-ID: <8bd0f97a0707211221l2c7fedeoea8612876350db6d@mail.gmail.com>
Date: Sat, 21 Jul 2007 15:21:43 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Oleg Verych" <olecom@flower.upol.cz>
Subject: Re: [kbuild-devel] [PATCH 25/33] kbuild: use POSIX BRE in headers install target
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070721100422.GK475@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184681344594-git-send-email-sam@ravnborg.org>
	 <11846813443187-git-send-email-sam@ravnborg.org>
	 <1184681344985-git-send-email-sam@ravnborg.org>
	 <11846813442810-git-send-email-sam@ravnborg.org>
	 <118468134441-git-send-email-sam@ravnborg.org>
	 <11846813441741-git-send-email-sam@ravnborg.org>
	 <1184681344376-git-send-email-sam@ravnborg.org>
	 <E1ICAEU-0005an-5F@flower>
	 <8bd0f97a0707210127m565f9b2cnc7a8a203f671e948@mail.gmail.com>
	 <20070721100422.GK475@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> On Sat, Jul 21, 2007 at 04:27:31AM -0400, Mike Frysinger wrote:
> []
> > if you want to make some micro optimization in the build install step,
> > sure ... but functionally, the difference is irrelevant considering
> > sed operates only on individual lines
>
> That was an attempt to support less sucking userspace in the kernel
> development. More readable, more memory/cpu effective, more portable.

while you could try and make a claim against memory/cpu effeciency, i
fail to see how the first or last claims could possibly be backed up

but again, if you feel that strongly about it, you're certainly free
to post a patch
-mike
