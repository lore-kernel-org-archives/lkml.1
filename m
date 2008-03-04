Return-Path: <linux-kernel-owner+w=401wt.eu-S1765979AbYCDWen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765979AbYCDWen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 17:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933749AbYCDWeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 17:34:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54438 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933714AbYCDWeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 17:34:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.25-rc3-mm1 (wakeup)
Date: Tue, 4 Mar 2008 23:33:12 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <20080304122414.f4b7e7f7.randy.dunlap@oracle.com>
In-Reply-To: <20080304122414.f4b7e7f7.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803042333.13300.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 4 of March 2008, Randy Dunlap wrote:
> On Tue, 4 Mar 2008 01:19:28 -0800 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/
> 
> Both x86_64 and i386 builds throw these messages at me:
> 
>   LD      arch/x86/kernel/acpi/realmode/wakeup.elf
> ld: warning: dot moved backwards before `.text'
> ld: warning: dot moved backwards before `.text'
> ld: warning: dot moved backwards before `.text'
>   OBJCOPY arch/x86/kernel/acpi/realmode/wakeup.bin

I think I saw something like this on a system with an "older" toolchain.
I'm not seeing it on openSUSE 10.3, though (using gcc 4.2.1).

Added CCs to the experts.

Thanks,
Rafael
