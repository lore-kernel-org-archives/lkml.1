Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbXGBBGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbXGBBGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 21:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbXGBBGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 21:06:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:4410 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940AbXGBBGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 21:06:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SfgPTAp59lmYi5rXobA4Ua92wFMl0iM/aAmsErY1Tbkv4f49wilDYlu6Yi1wtv2Ps3Ehjj3OtyIcRA5HTJFx2mxLfDJVjyShRt+NNM1IIZZspFoPBZyXFgeUdSbwqhIge3vFzEdtJe3WfCZy7ypjLmFtoIPXFwa+0wv4lcsz67g=
Message-ID: <9a8748490707011806t5db3c35cp9cbc675a162e8a17@mail.gmail.com>
Date: Mon, 2 Jul 2007 03:06:20 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "David Chinner" <dgc@sgi.com>
Subject: Re: [PATCH][XFS][resend] fix memory leak in xfs_inactive()
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070701223147.GU31489@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707010116.52012.jesper.juhl@gmail.com>
	 <20070701223147.GU31489@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/07, David Chinner <dgc@sgi.com> wrote:
> On Sun, Jul 01, 2007 at 01:16:51AM +0200, Jesper Juhl wrote:
> > (this is back from May 16 2007, resending since it doesn't look like
> > the patch ever made it in anywhere)
>
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/xfs/xfs_vnodeops.c.diff?r1=1.698;r2=1.699;f=h
>
> Will get merged in 2.6.23-rc1 window.
>
Ok, good to know, I thought it had been forgotten :-)
Thanks for the feedback Dave.

> Cheers,
>
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
