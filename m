Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbYC1KST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbYC1KST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 06:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYC1KSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 06:18:02 -0400
Received: from www.tglx.de ([62.245.132.106]:33711 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbYC1KSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 06:18:00 -0400
Date: Fri, 28 Mar 2008 11:17:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Jasper Bryant-Greene <jasper@unix.geek.nz>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc1 on Sun Ultra 40
In-Reply-To: <86802c440802171451p2728b29dnaf68a76dadcea21@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0803281116410.3781@apollo.tec.linutronix.de>
References: <1202901908.11100.8.camel@phobos.jasper.bg>  <1202929484.10687.1.camel@phobos.jasper.bg> <86802c440802171451p2728b29dnaf68a76dadcea21@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008, Yinghai Lu wrote:
> On Feb 13, 2008 11:04 AM, Jasper Bryant-Greene <jasper@unix.geek.nz> wrote:
> > I can confirm neither the boot hang with HPET enabled nor the other
> > unexplained boot hang after "NET: Registered protocol family 2" occur on
> > 2.6.24.2 on the same hardware. I still don't have an appropriate way to
> > debug the issue on 2.6.25-rc1, though...
> 
> boot message with debug in command line
> 
> also .config please

Is there any new info on this ? Does the problem still exist with 25-rc7 ?

Thanks,
	tglx
