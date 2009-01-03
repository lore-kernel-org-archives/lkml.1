Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbZACKDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbZACKDm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbZACKDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:03:32 -0500
Received: from ozlabs.org ([203.10.76.45]:55385 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbZACKDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:03:31 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: git-pull request for tip/cpus4096
Date: Sat, 3 Jan 2009 20:33:24 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>
References: <495E4837.8090600@sgi.com> <200901031631.47818.rusty@rustcorp.com.au> <20090103171838.0610d443.sfr@canb.auug.org.au>
In-Reply-To: <20090103171838.0610d443.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901032033.25087.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 16:48:38 Stephen Rothwell wrote:
> Hi Rusty,
> 
> On Sat, 3 Jan 2009 16:31:46 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> > >  arch/cris           : 0
> > >  arch/frv            : 0
> > >  arch/h8300          : 0
> > >  arch/m32r           : 0
> > >  arch/m68k           : 0
> > >  arch/mn10300        : 0
> > >  arch/um             : 0
> > >  arch/xtensa         : 0
> > 
> > These are the non-linux-next archs.
> 
> linux-next does include (in theory) cris, m68k and xtensa. 

m68k was actually OK, and xtensa did show the __fls issue (but it seems
broken by something else as well).

BTW, do you send mail automagically when something breaks, or does one have
to check the web page?

Thanks,
Rusty.
