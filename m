Return-Path: <linux-kernel-owner+w=401wt.eu-S1759222AbXGLKSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222AbXGLKSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 06:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXGLKRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 06:17:55 -0400
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:29889 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751673AbXGLKRy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 06:17:54 -0400
Message-Id: <4695C7870200005A0002760F@mcclure.wal.novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 12 Jul 2007 06:17:43 -0400
From: "Gregory Haskins" <ghaskins@novell.com>
To: <tglx@linutronix.de>
Cc: <jim.houston@ccur.com>, <joe.korty@ccur.com>, <mingo@elte.hu>,
       <dwalker@mvista.com>, "David Bahi" <DBahi@novell.com>,
       "Moiz Kohari" <MKohari@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, <dsaxena@plexity.net>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: Forward port of latest RT patch (2.6.21.5-rt20) to 2.6.22
	available
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 07:14 +0200, Thomas Gleixner wrote:
> On Wed, 2007-07-11 at 20:58 -0400, Gregory Haskins wrote:
> > 	Note also that we find that the resulting kernel does not boot on some
> > T60p thinkpads without "acpi=off".  We are still investigating the root
> > cause here.
> 
> Try "nohpet" for now. I'm investigating it on the -hrt side as well.
> 

Ah, good to know others are looking at it.

On a different front, I see .21.6-rt21 came out in the last 24 hours.
Were there any fixes that went in between rt20-21 here, or was it simply
a forward port?  If fixes, could you possibly share them to save me the
effort of working it out myself?  I will then push the next version of
the 22-based forward port to rt21 today.

Regards,
-Greg

