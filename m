Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbXIKSia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbXIKSia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763936AbXIKSiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:38:15 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:16089 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763708AbXIKSiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:38:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=uDuP9AoqzGadoQQ0mgCxS0Wrtq0dcHlMOThkBsXDeC1l6XImEtZandjX9TRY8jh9mMw9rZdkGUbp5R3dBWVjSX1phOqQxHQj2Ct09szA64yOcHHL31gmax5mKXk7ZIH55oNK79iU/1vUZz+uT6D/DAmLbDDfQyDxzvflj9A0IlI=
Message-ID: <75b66ecd0709111138xb5f6120qee40345378b188eb@mail.gmail.com>
Date: Tue, 11 Sep 2007 14:38:13 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       jgarzik <jgarzik@pobox.com>
In-Reply-To: <1189532202.21778.84.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com>
	 <1189532202.21778.84.camel@twins>
X-Google-Sender-Auth: a5d1ec8ddf1f24d9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/11/07, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2007-09-11 at 10:16 -0700, Randy Dunlap wrote:
>
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +Evolutions (GUI)
>
> I take it you mean: Evolution
>
> > +Some people seem to use this successfully for patches.
> > +
> > +What config options are needed?
>
> When composing mail select: Preformat
>   from Format->Heading->Preformatted (Ctrl-7)
>   or the toolbar
>
> Then use:
>   Insert->Text File... (Alt-n x)
>
> to insert the patch.

You can also diff -Nru old.c new.c | xclip, select Preformat, then
paste with the middle button.

Lee
