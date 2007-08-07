Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbXHGTvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbXHGTvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 15:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbXHGTvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 15:51:43 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:55244 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbXHGTvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 15:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gHybSHdWHrExFiLezCGjft+cn2I+i1Ki9lGe0V1FoRuBAoOYVskO2sf+DBSin1w4ENIeg8ogkt4zNYJho9hlJdxLmZ+cUqZdz2zltUFSSj3nU3coX6Ue2/+KBhS3Pc4xal+WOfMDx2QlxpPjs0W2356JMc/U1Sj8J02mrIvBnSs=
Message-ID: <9a8748490708071251l72d1e564u3f0d3bd5b6e4110d@mail.gmail.com>
Date: Tue, 7 Aug 2007 21:51:40 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "David Chinner" <dgc@sgi.com>
Subject: Re: [PATCH][RESEND] fix a potential NULL pointer deref in XFS on failed mount.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com
In-Reply-To: <20070806005214.GK31489@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708042030.21375.jesper.juhl@gmail.com>
	 <20070806005214.GK31489@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/07, David Chinner <dgc@sgi.com> wrote:
> On Sat, Aug 04, 2007 at 08:30:21PM +0200, Jesper Juhl wrote:
> > Back in 2006 (2006-10-31 to be specific, reposted on 2006-11-16), I
> > submitted a patch to fix a potential NULL pointer deref in XFS on
> > failed mount.
>
> Already checked into xfs-dev tree. Will go to next mainline merge.
>
> http://oss.sgi.com/archives/xfs/2007-08/msg00030.html
>

Ok. Thanks a lot for the feedback David.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
