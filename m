Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbYARAfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbYARAfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757086AbYARAfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:35:22 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:41511 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290AbYARAfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:35:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xnT6jNckFMix/cPOmoCe7/tyJcXfvllsjgoFpea7Tw2dhkf2iMSkKwxGh8dAlXW+hgNuyZIuw9zT2OG+AZXZ26xHFQ4idvbDBWyOWODjZekjQLPe594ylel8caF9NL8sIvlw5MPRtZwOXWqIHJF3pxTRhc6jRoJSL1noLy2grHc=
Message-ID: <9a8748490801171635u4c1940fdm5d25081209599184@mail.gmail.com>
Date: Fri, 18 Jan 2008 01:35:20 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Ed L. Cashin" <ecashin@coraid.com>
Subject: Re: [PATCH] Documentation: Add 00-INDEX file for AoE
Cc: linux-doc@vger.kernel.org, "Rob Landley" <rob@landley.net>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080114171830.GL3304@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.00.0801130241110.2235@dragon.funnycrock.com>
	 <20080114171830.GL3304@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/2008, Ed L. Cashin <ecashin@coraid.com> wrote:
> On Sun, Jan 13, 2008 at 02:44:48AM +0100, Jesper Juhl wrote:
> > Documentation/aoe/ is missing a 00-INDEX file. Add one.
>
> Thanks.  I think that it would help to clarify that using udev is the
> norm, and that the mkdev and mkshelf scripts are just examples to show
> how you could do it manually.
>
> Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
>
...

Thanks Ed.

I'll submit a new patch with your changes as well.
I've got a few more of these on the way, so I'll send them as a
complete series in a few days.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
