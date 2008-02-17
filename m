Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbYBQUN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbYBQUN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbYBQUNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:13:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39180 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbYBQUNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:13:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.25-rc2-mm1 (build failure)
Date: Sun, 17 Feb 2008 21:12:15 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       len.brown@intel.com
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <20080216214627.e8248706.akpm@linux-foundation.org> <20080217195256.GC6115@elf.ucw.cz>
In-Reply-To: <20080217195256.GC6115@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802172112.15705.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of February 2008, Pavel Machek wrote:
> Hi!
> 
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
> > > 
> > > When SMP=n, x86_64 build gets:
> > > 
> > > arch/x86/kernel/built-in.o: In function `acpi_save_state_mem':
> > > (.text+0xfd7f): undefined reference to `setup_trampoline'
> > > make[1]: *** [.tmp_vmlinux1] Error 1
> > > 
> > 
> > Thanks.  Say hello to Pavel.
> 
> Sorry, I was in mountains, with electricity 5 hours a day... I believe
> this was solved already?

I've sent a patch, it's being tested.

Thanks,
Rafael
