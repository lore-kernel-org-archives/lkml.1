Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbYAHAq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbYAHAq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 19:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYAHAqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 19:46:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39292 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbYAHAqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 19:46:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Re: Unify arch/x86/kernel/acpi/sleep*.c
Date: Tue, 8 Jan 2008 01:48:13 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20080107122305.GA11062@elf.ucw.cz> <200801071741.02577.rjw@sisk.pl>
In-Reply-To: <200801071741.02577.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801080148.14208.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of January 2008, Rafael J. Wysocki wrote:
> On Monday, 7 of January 2008, Pavel Machek wrote:
> > Unify arch/x86/kernel/acpi/sleep*.c
> > 
> > Pretty trivial unification; when two functions differed, it was
> > usually in error handling, and better of the two was picked up.
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> Looks-okay-to: Rafael J. Wysocki <rjw@sisk.pl>
> 
> > ---
> > 
> > (Seems to work on i386, but needs some x86-64 testing.)
> 
> I'll test it later today.

Tested, works.

Thanks,
Rafael
