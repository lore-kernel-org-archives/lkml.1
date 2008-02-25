Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbYBYKwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbYBYKwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 05:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYBYKv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 05:51:58 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4794 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbYBYKv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 05:51:56 -0500
Date: Mon, 25 Feb 2008 10:53:04 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Benny Halevy <bhalevy@panasas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Change a WARN message in checkpatch
Message-ID: <20080225105304.GE2604@shadowen.org>
References: <20080114232913.2555d392@paolo-desktop> <20080128145605.GI12910@shadowen.org> <4d8e3fd30801280713n7139223fj91adca85c76b60ad@mail.gmail.com> <4d8e3fd30802230538k7be1cc6bja9130e65fc6f5997@mail.gmail.com> <47C18AAB.7050503@panasas.com> <4d8e3fd30802241014g503c78a2wc08bd1939657802b@mail.gmail.com> <20080225032944.GA30294@shadowen.org> <4d8e3fd30802242251p7a45482dof23aed1eed0afdc2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d8e3fd30802242251p7a45482dof23aed1eed0afdc2@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 10:21:01AM +0330, Paolo Ciarrocchi wrote:
> On 2/25/08, Andy Whitcroft
> > As we want the messages to be as short as possible, I am leaning towards
> > standardising on:
> >
> > spaces prohibited <where>
> > spaces required <where>
> >
> in that case i would prefer:
>  space not required <where>
>  space required <where>

"not required" implies that you don't have to have the space, but you
can can have it if you want.  So I don't think thats quite right either.

-apw
