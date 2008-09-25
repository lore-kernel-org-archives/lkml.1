Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbYIYQ7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbYIYQ7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYIYQ7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:59:09 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:24676 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbYIYQ7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:59:08 -0400
Message-ID: <48DBC35B.3050105@ct.jp.nec.com>
Date: Thu, 25 Sep 2008 09:59:07 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 1/4] x86: signal_32.c: introduce signr_convert()
References: <48DAF315.7070700@ct.jp.nec.com> <20080925081420.GB30349@elte.hu>
In-Reply-To: <20080925081420.GB30349@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> applied your patches to tip/x86/signal:
> 
> 4694d23: x86: signal_32.c: introduce macro ia32_setup_frame and ia32_setup_rt_frame
> 455edbc: x86: signal: introduce helper macro is_ia32
> b94fd69: x86: signal_64.c: introduce helper function signr_convert()
> 8d8c13b: x86: signal_32.c: introduce signr_convert()
> 
> thanks! FYI, your other 13 x86 signal code unification commits and other 
> x86-signals enhancements passed testing just fine so far.

Hi, Ingo.
Thanks for that information and testing my patches!
It's very important to test patches.

thanks,
Hiroshi Shimamoto
