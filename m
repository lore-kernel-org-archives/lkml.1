Return-Path: <linux-kernel-owner+w=401wt.eu-S932103AbXBTShF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbXBTShF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 13:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932684AbXBTShE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 13:37:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:23183 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103AbXBTShB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 13:37:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Whacgz33xsRg6mSOBhRIeLlDEZE/qgVPgubsuOoFG5zfjG0RaobL8NMfwd+yXaRsv5oWAB+PsBe2qh4ZeIh4GPQAo8ia1aOexe6DJk2JTtboTCOhfJQedebdUebA0T9reyec86DALlDDbXrLNEttYgVrpGL0GzBI99B0uIUGzPU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tilman Schmidt <tilman@imap.cc>
Subject: Re: [PATCH] kbuild: Add the code maturity levels DEPRECATED and OBSOLETE.
Date: Tue, 20 Feb 2007 19:42:50 +0100
User-Agent: KMail/1.9.5
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>
References: <Pine.LNX.4.64.0702181203360.5131@CPE00045a9c397f-CM001225dbafb6> <200702181935.07454.bzolnier@gmail.com> <45DB218E.1080106@imap.cc>
In-Reply-To: <45DB218E.1080106@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702201942.50186.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 20 February 2007 17:27, Tilman Schmidt wrote:
> On Sun, 18 Feb 2007 19:35:07 +0100, Bartlomiej Zolnierkiewicz wrote:
> > I think that the patch is useful and that the distinction between
> > DEPRECATED and OBSOLETE options is quite clear:
> > 
> > * DEPRECATED == new better code is available, old code scheduled for removal
> > 
> > * OBSOLETE == no replacement yet but the code is broken by design
> >   and unreliable, not scheduled for removal yet
> 
> Is that really the consensus on these definitions? I thought it was
> more or less the opposite:
> 
> * DEPRECATED == no (complete) replacement available yet, but it has
>   been decided that this code is less than optimal and alternatives
>   should be preferred
> 
> * OBSOLETE == replacement available, no reason to use this code anymore

Indeed, this way it makes more sense for me but I'll leave the definitive
answer to a native speaker(s).

Bart
