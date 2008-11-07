Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbYKGTD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbYKGTD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbYKGTDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:03:21 -0500
Received: from smtp-out-45.synserver.de ([217.119.50.45]:1025 "HELO
	smtp-out-45.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751164AbYKGTDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:03:20 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 666
Date: Fri, 7 Nov 2008 20:03:17 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [arch/x86/vdso/vdso32-syms.lds] Error 1
Message-ID: <20081107190317.GA2442@gentoox2.trippelsdorf.de>
References: <20081107181117.GA29006@gentoox2.trippelsdorf.de> <49148E66.4040109@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49148E66.4040109@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 10:52:22AM -0800, H. Peter Anvin wrote:
> Markus Trippelsdorf wrote:
> > --- -   2008-11-07 18:51:36.392997346 +0100
> > +++ arch/x86/vdso/vdso32-int80-syms.lds 2008-11-07 18:51:36.283820343 +0100
> > @@ -3,5 +3,3 @@
> >  VDSO32_sigreturn = 0x0400;
> >  VDSO32_vsyscall = 0x0420;
> >  VDSO32_vsyscall_eh_frame_size = 0x040;
> > -VDSO32_vsyscall = 0x0420;
> > -VDSO32_vsyscall_eh_frame_size = 0x040;
> > make[1]: *** [arch/x86/vdso/vdso32-syms.lds] Error 1
> > make: *** [arch/x86/vdso] Error 2
> > 
> 
> Could you please tar up your arch/x86/vdso directory and send me?

Will do so.

> Also, what version of binutils are you running?

GNU ld (Linux/GNU Binutils) 2.19.50.0.1.20081007
-- 
Markus
