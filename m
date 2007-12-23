Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbXLWNeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbXLWNeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 08:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbXLWNeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 08:34:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55385 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbXLWNeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 08:34:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc6-mm1
Date: Sun, 23 Dec 2007 14:53:34 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071223130029.GA6815@elte.hu> <200712231448.33882.rjw@sisk.pl>
In-Reply-To: <200712231448.33882.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712231453.35497.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 23 of December 2007, Rafael J. Wysocki wrote:
> On Sunday, 23 of December 2007, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > Well it doesn't build on x86-64 for me:
> > > 
> > >   CHK     include/linux/compile.h
> > >   CC      arch/x86/ia32/../../../fs/compat_binfmt_elf.o
> > > Assembler messages:
> > > Fatal error: can't create arch/x86/ia32/../../../fs/.tmp_compat_binfmt_elf.o: No such file or directory
> > > make[2]: *** [arch/x86/ia32/../../../fs/compat_binfmt_elf.o] Error 2
> > > 
> > > I will post the .config if anyone is interested.
> > 
> > yes, please send the .config.
> 
> Attached.
> 
> It also may be relevant that I compile the kernel with "make O=../build".

I ran the compilation once again and it worked.  Strange.

Thanks,
Rafael
