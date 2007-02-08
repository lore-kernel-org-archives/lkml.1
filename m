Return-Path: <linux-kernel-owner+w=401wt.eu-S1422773AbXBHMwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422773AbXBHMwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 07:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422869AbXBHMwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 07:52:42 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:53206 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422773AbXBHMwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 07:52:42 -0500
Date: Thu, 8 Feb 2007 13:52:40 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: David Miller <davem@davemloft.net>
cc: Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: checker-shell still hosed...
In-Reply-To: <Pine.LNX.4.62.0702081340340.28405@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.62.0702081351470.28405@pademelon.sonytel.be>
References: <20070208.030531.112264703.davem@davemloft.net>
 <20070208.041004.07457320.davem@davemloft.net> <20070208.041229.18308943.davem@davemloft.net>
 <Pine.LNX.4.62.0702081340340.28405@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007, Geert Uytterhoeven wrote:
> On Thu, 8 Feb 2007, David Miller wrote:
> > From: David Miller <davem@davemloft.net>
> > Date: Thu, 08 Feb 2007 04:10:04 -0800 (PST)
> > 
> > > Removing them makes the spaces go away.
> > 
> > FWIW, this patch below seems to fix the sparc64 build for me.
> > 
> > Paul, does it work for you on powerpc too?
> 
> Thx, it seems to build now. I'll tell you whether it boots on PS3 soon.

Build and boot were successful.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
