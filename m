Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbXFGNTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbXFGNTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 09:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760359AbXFGNSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 09:18:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:19478 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760018AbXFGNSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 09:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c5L9AoNwxA3mfklRux6ep8+1/zHixmSMbJaYffbS0zLIfVe+ATs3lRZR8G/CrznB7CzxRdJdq0VuWI483AXHlioR3H0TyWTlOR9/Wkzz28gp3Nv1QFQII6ss86ncCi91zSkw/TNyF9ZROgO/qjQsYin6conukRrR5O6/qWh9jvg=
Message-ID: <9a8748490706070618t3c27c1b3hb10846cf5355653b@mail.gmail.com>
Date: Thu, 7 Jun 2007 15:18:48 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Add missing files and dirs to 00-INDEX in Documentation/
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070606093651.179a13ef.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706061620.33881.jesper.juhl@gmail.com>
	 <20070606093651.179a13ef.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Wed, 6 Jun 2007 16:20:32 +0200 Jesper Juhl wrote:
>
> >
> > This patch adds descriptions for a number of missing files and directories
> > to the Documentation/00-INDEX file.
> > People really should learn to keep this file up-to-date when adding or
> > moving documentation...
>
> /me raises hand.
> Thanks.
>
I'll take that as an implicit ACK ;-)

Now we just need someone to merge the patch (optimistically adding
akpm to Cc - for real this time) ...

> > Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

http://lkml.org/lkml/diff/2007/6/6/191/1

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
