Return-Path: <linux-kernel-owner+w=401wt.eu-S933493AbXHVXfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493AbXHVXfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 19:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763324AbXHVXff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 19:35:35 -0400
Received: from fed1rmmtao104.cox.net ([68.230.241.42]:62721 "EHLO
	fed1rmmtao104.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763025AbXHVXfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 19:35:34 -0400
From: Junio C Hamano <junkio@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [4/4] 2.6.23-rc3: known regressions
References: <46C098FD.1030601@googlemail.com>
	<alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org>
	<alpine.LFD.0.999.0708202255130.30176@woody.linux-foundation.org>
	<200708202334.38261.david-b@pacbell.net>
	<alpine.LFD.0.999.0708202348460.30176@woody.linux-foundation.org>
	<alpine.LFD.0.999.0708210016420.30176@woody.linux-foundation.org>
	<alpine.LFD.0.999.0708212026200.30176@woody.linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Date: Wed, 22 Aug 2007 16:35:27 -0700
In-Reply-To: <alpine.LFD.0.999.0708212026200.30176@woody.linux-foundation.org>
	(Linus Torvalds's message of "Tue, 21 Aug 2007 20:34:31 -0700 (PDT)")
Message-ID: <7vir77w3b4.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Well, my one remaining child said today that "I got so much time on 
> webkinz today - yesterday the mouse locked up after five minutes".
>
> Apparently it hadn't had the mouse lock up at all today.
>
> So I really do believe that that 196705c9bb commit caused problems on 
> intel-only USB machines too ("ondemand" cpufreq governor, switching 
> between 1.0-1.66 Ghz using acpi-cpufreq: totally bog-standard in all 
> respects, in other words).
>
> 		Linus

Sorry for being way offtopic, but the above message reminded me
of commit 869659a6 from git.git repository, also this message:

    http://www.gelato.unsw.edu.au/archives/git/0607/24208.html

By the way, Linus, please let me know if you get this message
via vger but not via the direct path to you.  I seem to have
been getting bounces for mails to you and andrew from my ISP in
the past few weeks.
