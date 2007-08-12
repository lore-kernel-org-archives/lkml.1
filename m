Return-Path: <linux-kernel-owner+w=401wt.eu-S937871AbXHLULV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937871AbXHLULV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761988AbXHLULK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:11:10 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:31945 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761694AbXHLULI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:11:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JRCd/GECJEznX8t+kXpDDqI0S/hEkgEKv7c83a52prxGvVCrTIdVj8cme6w9LBjwBf84a6r7JaS9GRo3CHXnE2On275BJvVJuxQ2MGRXgaXPLoXE5UxOm9CjENyUVL4V8Xxku3MLYz6AaSbpj0LaEbw+7J3etGQcv1GX8ig7pBA=
Message-ID: <9a8748490708121311m643e85b1p88ba679f7272c411@mail.gmail.com>
Date: Sun, 12 Aug 2007 22:11:06 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [PATCH 0/5] Add some missing Documentation/*/00-INDEX files
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>, linux-doc@vger.kernel.org,
       "Randy Dunlap" <rdunlap@xenotime.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200708121503.30631.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708120045.03032.jesper.juhl@gmail.com>
	 <46BF01A5.9060003@s5r6.in-berlin.de>
	 <200708121503.30631.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/07, Rob Landley <rob@landley.net> wrote:
> On Sunday 12 August 2007 7:48:37 am Stefan Richter wrote:
> > Isn't it with 00-INDEX just like with the "Last Updated:" footers in
> > documentation texts?
> >
> > They are metadata which will be almost always out of date.
>
> If nothing is using them, they'll bit-rot, yes.  Way of the world.  But I've
> found a use for them.  Therefore, I'm interested in getting them up to date
> and then keeping them there.

So, do you want me to create more of these?
If you want them, could you perhaps start by ACK'ing the first 5
patches to help me get them merged?
Once I see the first 5 merged I'll start creating more, but I don't
want to waste time doing so before that.

>I already wrote an automatic checker to tell me
> how they differ from reality, which is half the battle.

I started writing such a script myself yesterday, but it's not done
yet. If you already have one that works could I have a copy please?
That would make my life easier if I'm to help you with this.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
