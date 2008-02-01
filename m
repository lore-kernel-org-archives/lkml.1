Return-Path: <linux-kernel-owner+w=401wt.eu-S934991AbYBABDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934991AbYBABDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 20:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765122AbYBABDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 20:03:09 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45721 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934351AbYBABDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:03:08 -0500
Date: Fri, 1 Feb 2008 02:03:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz
Subject: Re: how to tell i386 from x86-64 kernel
Message-ID: <20080201010319.GA5112@elf.ucw.cz>
References: <20080201004212.GA2818@elf.ucw.cz> <2c0942db0801311646s40368a89r537a7d576ba57981@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0801311646s40368a89r537a7d576ba57981@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-01-31 16:46:57, Ray Lee wrote:
> On Jan 31, 2008 4:42 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Quiz: on a booted system, how do you tell 32bit from 64bit kernel?
> 
> Uhm, is this a trick question? What's wrong with uname(2)?

No, it is a tricky question. You are right, uname -a tells me. Sorry.

Still, it would be nice to print it as a first message of dmesg, so
that it automatically gets included with problem reports... on
easy-to-see place.

								Pavel

Linux version 2.6.24-rc8 (pavel@amd) (gcc version 4.1.3 20071209 (prerelease) (Debian 4.1.2-18)) #65 SMP Thu Jan 31 00:02:37 CET 2008
BIOS-provided physical RAM map:


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
