Return-Path: <linux-kernel-owner+w=401wt.eu-S1760141AbZACUtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbZACUtE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZACUsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:48:52 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:40394 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZACUsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:48:52 -0500
Date: Sat, 3 Jan 2009 21:50:31 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Brueckl <ib@wupperonline.de>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Lee Leahu <linuxtwidler@gmail.com>
Subject: Re: [PATCH] section mismatch
Message-ID: <20090103205031.GB5388@uranus.ravnborg.org>
References: <495e1180@wupperonline.de> <495f4893@wupperonline.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495f4893@wupperonline.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 12:16:00PM +0100, Ingo Brueckl wrote:
> I wrote in http://lkml.org/lkml/2009/1/2/130 on Fri, 02 Jan 2009:
> 
>  > The following patch has already been suggested by someone named
>  > linuxtwid...@gmail.com but hasn't been applied yet.
> 
> It was Lee Leahu (http://lkml.org/lkml/2008/10/15/385).
> 
>  > fix section mismatch warning at compile time in
>  > vmlinux.o(.cpuinit.data+0x0)
>  > It is beyond my scope so could please somebody confirm whether this is the
>  > right thing to do?
> 
> Nobody?

I expect the x86 guys will review it.
I do not plan to do so.

	Sam
