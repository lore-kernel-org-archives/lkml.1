Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYAYAuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYAYAuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 19:50:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbYAYAtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 19:49:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45207 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbYAYAtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 19:49:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
Date: Fri, 25 Jan 2008 01:46:09 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Campbell <ijc@hellion.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Mika =?iso-8859-1?q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <1201121530.30671.15.camel@cthulhu.hellion.org.uk> <20080125002054.GA2059@elf.ucw.cz> <47992D0E.2070700@zytor.com>
In-Reply-To: <47992D0E.2070700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801250146.11004.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 25 of January 2008, H. Peter Anvin wrote:
> Pavel Machek wrote:
> >>>
> >> I just looked at the ACPI suspend code, and it looks like it hacks its own 
> >> identity map at runtime.  Pavel, am I reading that code right?
> > 
> > Yes, I think so, I believe we do it on both 32 and 64 bit now.

For clarity, are you referring to the code in arch/x86/kernel/acpi ?

Rafael
