Return-Path: <linux-kernel-owner+w=401wt.eu-S1760772AbYC1PCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772AbYC1PCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 11:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759007AbYC1PCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 11:02:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:55310 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991AbYC1PCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 11:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bjx6d3xAbfhw5raXD9CP5gbz7dZT8YK+5fR1bb44n1HlMHLxmWc20IKKrbfuzNr6YgEGnO7RsC9wzr54R7mwTaGXBnjHrbsiyfDahfhlxN89kRkLRiTMPsClYeDJW2foiFn/VjDCoLLAal4+2dyIiSsAOAJHt5cxAkd41b/nx80=
Message-ID: <86802c440803280751l33bc74e3y777f4c6da600ee6a@mail.gmail.com>
Date: Fri, 28 Mar 2008 07:51:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: 2.6.25-rc1 on Sun Ultra 40
Cc: "Jasper Bryant-Greene" <jasper@unix.geek.nz>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.00.0803281116410.3781@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202901908.11100.8.camel@phobos.jasper.bg>
	 <1202929484.10687.1.camel@phobos.jasper.bg>
	 <86802c440802171451p2728b29dnaf68a76dadcea21@mail.gmail.com>
	 <alpine.LFD.1.00.0803281116410.3781@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 3:17 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Sun, 17 Feb 2008, Yinghai Lu wrote:
>  > On Feb 13, 2008 11:04 AM, Jasper Bryant-Greene <jasper@unix.geek.nz> wrote:
>  > > I can confirm neither the boot hang with HPET enabled nor the other
>  > > unexplained boot hang after "NET: Registered protocol family 2" occur on
>  > > 2.6.24.2 on the same hardware. I still don't have an appropriate way to
>  > > debug the issue on 2.6.25-rc1, though...
>  >
>  > boot message with debug in command line
>  >
>  > also .config please
>
>  Is there any new info on this ? Does the problem still exist with 25-rc7 ?

No response yet.

YH
