Return-Path: <linux-kernel-owner+w=401wt.eu-S1751099AbZFLKom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751099AbZFLKom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbZFLKoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:44:25 -0400
Received: from smtp-out.google.com ([216.239.45.13]:42032 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbZFLKoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:44:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ulxeDrJ4qHE4CT0VsPxSzNzw0TkJ5ZRewOkltuQvGJr0ZTuJVt2ECv4zM92MJ8JLg
	LTs8DwlI7eLoEaX/Z7xZw==
MIME-Version: 1.0
In-Reply-To: <20090612103521.GD18682@elf.ucw.cz>
References: <20090611132134.GA11199@atomide.com>
	 <20090611140038.GB11199@atomide.com>
	 <20090611140624.GS795@n2100.arm.linux.org.uk>
	 <alpine.LFD.2.00.0906111314510.31536@xanadu.home>
	 <4A3175AC.9070100@bluewatersys.com>
	 <alpine.LFD.2.00.0906112105220.31536@xanadu.home>
	 <4A31AECA.6070303@bluewatersys.com>
	 <alpine.LFD.2.00.0906112138090.31536@xanadu.home>
	 <a55d774e0906111916y2f49e5a9q362e12b52fb5414a@mail.gmail.com>
	 <20090612103521.GD18682@elf.ucw.cz>
Date: Fri, 12 Jun 2009 03:44:21 -0700
Message-ID: <a55d774e0906120344p57226dd4ve526f274a2bf7c8e@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Nicolas Pitre <nico@cam.org>, Ryan Mallon <ryan@bluewatersys.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, lkml <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 3:35 AM, Pavel Machek<pavel@ucw.cz> wrote:
>>
>> My hope with the msm support is to get buildable, bootable (we're
>> there now), style-clean (we probably have stuff that needs help yet,
>
> I still can't get it to boot :-(.

I think the cupcake userspace and the latest 2.6.29 kernel aren't
getting along.  I'm putting together instructions for building a
minimal userspace (what we call tiny android -- and what I use for
bringup and kernel testing), and once I've had a chance to verify that
everything works end-to-end with the latest kernel, donut branch, and
have verified this on ADP1, I'll send an update.  Probably some time
over the weekend.

Brian
