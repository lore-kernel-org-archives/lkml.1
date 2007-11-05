Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbXKEAQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbXKEAQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 19:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbXKEAQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 19:16:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57300 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbXKEAQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 19:16:19 -0500
Message-ID: <472E6001.9040404@zytor.com>
Date: Sun, 04 Nov 2007 16:12:49 -0800
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
References: <200711042259.lA4Mxa0n025210@tazenda.hos.anvin.org> <alpine.LFD.0.999.0711041512530.15101@woody.linux-foundation.org> <472E551E.2010507@zytor.com> <alpine.LFD.0.999.0711041546510.15101@woody.linux-foundation.org> <472E5DAB.8080804@zytor.com>
In-Reply-To: <472E5DAB.8080804@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> Apparently because the Intel documentation disagrees with itself. That's 
> all.
> 

Just to be perfectly clear: I much prefer the code with the short (near) 
jump, because it keeps the code cleaner.  I have sent a patch to Mikael 
to test out.

	-hpa
