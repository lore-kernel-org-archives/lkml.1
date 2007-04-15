Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbXDOV6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbXDOV6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 17:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbXDOV6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 17:58:36 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:6760 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbXDOV6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 17:58:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mkwqrPhkAtgewvRfleGEKtXzmaOKFglIg8bAZ54dpPfjWEy8pBwlQlKriRtEZnGidRXqgEwE93bWLsud3RGb2OyWcDR1qwouLnB3I6D28SPFvTrXxVJD+E5wEcVGKA2+jIoUpNmcFnYjjE8CqRtNL2WfOVlTvGGvO04Mmk8YGhY=
Message-ID: <9a8748490704151458s32b7f066h62b4d3a565b539ed@mail.gmail.com>
Date: Sun, 15 Apr 2007 23:58:34 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "David R. Litwin" <presently42@gmail.com>
Subject: Re: ZFS with Linux: An Open Plea
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <op.tqqwdfzcftfxs2@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <op.tqqwdfzcftfxs2@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/07, David R. Litwin <presently42@gmail.com> wrote:
> Before I go on, let me appologise. I don't really know what I hope to
> accomplish, beyond trying to garner thoughts (and support?) for the topic.
>
> Essentially: I want to use Linux and ZFS. I don't particularly care about
> licences or any of the rest of that nonsense.

The license that protects the code we write is far from nonsense.

>The code is there; it merely
> needs to be made to work with Linux. Done and done -- provided I can find
> some one to do this for me (I'd do it myself, but I haven't the foggiest
> notion how to go about such a feat).
>
I suggest the first thing you do is contact the ZFS developers and
convince them to release their code under a license that's GPL
compatible, then we can start looking at a Linux port.

> By the way, forget about this FUSE business. I don't know why they're
> bothering: It's not real, it's slow and, in general, silly.
>
FUSE is nice for trying out new and interresting ideas in userspace -
it has its uses.

> What are the thoughts of the Linux community?
>
Can't tell you that, all I can tell you is my own oppinion.  I believe
ZFS for Linux would be interresting, if not for any other reason then
for compatibility. I'd personally like to see it - but, settle the
license issue first.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
