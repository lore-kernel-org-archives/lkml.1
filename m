Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbXGOV3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbXGOV3t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 17:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbXGOV3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 17:29:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:17584 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbXGOV3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 17:29:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kyjQ6YHG8w0BDKJENd6Ax4NN0E6VpxqWgfgR5XOKgHwp1uhoJxRHjU41AfDzq+jD3Y0gKR9qAlH9B8/02YMbqLBNyezyMN5kelp1fq7cVBRttrsAKDZtCHEt9xu/Ozpau6DR9jLr8urB2YLeRP4gEcslQPCVDHaZqdvQdxWTuHQ=
Message-ID: <9a8748490707151429h73c46157w441287089d150fed@mail.gmail.com>
Date: Sun, 15 Jul 2007 23:29:40 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "TripleX Chung" <triplex@zh-kernel.org>
Subject: Re: Ask for help, about the trivial patches.
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <469A4B9B.4040008@zh-kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4697C980.1040902@zh-kernel.org>
	 <9a8748490707131354y37793f0ag2c01b2bdf968f8cc@mail.gmail.com>
	 <469A4B9B.4040008@zh-kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/07, TripleX Chung <triplex@zh-kernel.org> wrote:
> Jesper Juhl wrote:
> > Note: my explanations below are based on how I understand these
> > things, but I'm not the trivial patch monkey nor did I help create
> > these guidelines, so I'm in no way authoritative on the subject.
> >
> > On 13/07/07, TripleX Chung <triplex@zh-kernel.org> wrote:
> >> I am working on the chinese translated version of
> >> Documentation/SubmittingPatches and get some problem about the "Trivial
> >> patches".I can not understand what "Trivial patches" exactly means.The
> >> documentation said:
> >>
> >
> > If you are unclear of the meaning of the word "trivial", then take a
> > look here for an explanation: http://www.m-w.com/dictionary/trivial
> >
> Thanks for your help.
> But I still have problems.
> Trivial means "of little worth or importance". But some of the examples
> in the rules are important, like "runtime fixes". Spell fixes must be
> unimportant, but most of the runtime fixes like memory leaks or NULL
> pointers must be important. I was still a little confused with them.
>

Think more along the lines of "simple, localized & easy to verify".

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
