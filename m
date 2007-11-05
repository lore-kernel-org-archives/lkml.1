Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbXKEAHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbXKEAHF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 19:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXKEAGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 19:06:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39167 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbXKEAGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 19:06:54 -0500
Message-ID: <472E5DAB.8080804@zytor.com>
Date: Sun, 04 Nov 2007 16:02:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>,
       Eric Biederman <ebiederm@xmission.com>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486DX4
References: <200711042259.lA4Mxa0n025210@tazenda.hos.anvin.org> <alpine.LFD.0.999.0711041512530.15101@woody.linux-foundation.org> <472E551E.2010507@zytor.com> <alpine.LFD.0.999.0711041546510.15101@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0711041546510.15101@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> And Linux always did it correctly. I don't understand why you disagree, 
> and why Jeremy says
> 
> 	"Having successfully broken the rules for a long time so far, 
> 	 maybe we can get away with still cutting corners..."
> 
> when the fact is, we used to *not* cut corners, we used to *not* break the 
> rules, and what we used to do (a short jump immediately after setting PE) 
> was exactly what Intel always said you should do, and there is no question 
> what-so-ever about it.
> 

Apparently because the Intel documentation disagrees with itself. 
That's all.

	-hpa
