Return-Path: <linux-kernel-owner+w=401wt.eu-S932158AbYEHQx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbYEHQx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 12:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764708AbYEHQwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 12:52:42 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:39410 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762709AbYEHQwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 12:52:40 -0400
Message-ID: <48233003.6010905@keyaccess.nl>
Date: Thu, 08 May 2008 18:53:23 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] x86: introduce a new Linux defined feature flag for PAT
 support
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl> <482233F0.7040000@zytor.com> <48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl> <alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org> <48224930.9030901@keyaccess.nl> <48225DEC.2030502@keyaccess.nl> <alpine.LFD.1.10.0805071857430.3024@woody.linux-foundation.org> <4822614B.6080706@zytor.com> <alpine.LFD.1.10.0805071923030.3024@woody.linux-foundation.org> <48226569.7010906@zytor.com> <alpine.LFD.1.10.0805081307520.3318@apollo.tec.linutronix.de> <482311C9.2010603@keyaccess.nl> <alpine.LFD.1.10.0805081650440.3318@apollo.tec.linutronix.de> <48232ECB.1060803@zytor.com>
In-Reply-To: <48232ECB.1060803@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-05-08 18:48, H. Peter Anvin wrote:

> No, it doesn't.  Although it is badly named, it refers to the common 
> capability set of all online CPUs.

Yup, all fine. Will report ofcourse when anything bad happens with PAT
support here.

Rene.
