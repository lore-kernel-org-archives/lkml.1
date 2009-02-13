Return-Path: <linux-kernel-owner+w=401wt.eu-S1761896AbZBMS7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761896AbZBMS7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760796AbZBMS7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:59:21 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:33297 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbZBMS7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:59:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u86gUPac01GCW2/MsFbxjA08sgKEkAJ3S73Yo2ixA+kQigdZX7MgRHlvSeMEbKLefs
         WYuXJQvVzLNpUu4lWo8GvGrqkHOZi+tZylnTM2t092scQQni2ngJd+Rj+dW3SDkr1n02
         ZyOZfffCQ2fPzrHYgQF16pVdvOV/F7auVX2tw=
Date: Fri, 13 Feb 2009 21:59:16 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Junio C Hamano <junio@pobox.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ingo Oeser <ioe-lkml@rameria.de>, Peter Zijlstra <peterz@infradead.org>,
       L-K <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: git-send-email
Message-ID: <20090213185916.GA22651@localhost>
References: <1234451714.10603.22.camel@laptop> <200902121825.35021.ioe-lkml@rameria.de> <20090212192104.GD15809@csclub.uwaterloo.ca> <7vmycrf5dv.fsf@gitster.siamese.dyndns.org> <4995B83C.6000108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4995B83C.6000108@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Fri, Feb 13, 2009 at 10:13:16AM -0800]
| Junio C Hamano wrote:
| > 
| > I personally prefer the former, but as you hopefully all found out by now,
| > the choice between these two is just the matter of personal taste, and
| > there is no clear majority.
| > 
| 
| Quite on the contrary.  I think there is a clear majority in favor of
| --no-chain-reply-to.  Let me add my voice to that chorus, too.
| 
| 	-hpa
| 
| -- 
| H. Peter Anvin, Intel Open Source Technology Center
| I work for Intel.  I don't speak on their behalf.
| 

If that somehow matter -- I'm _for_ --no-chain-reply-to
by default too. It happens several times with me that
I missed this option even having in mind --no-chain-reply-to
behaviour expected.

On the other hand I think --no-chain-reply-to has much
sense if pathes being sent are not numbered in title.
But on LKML I can't remember even one mail-thread which was
not numbered :)

	- Cyrill -
