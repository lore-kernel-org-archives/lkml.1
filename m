Return-Path: <linux-kernel-owner+w=401wt.eu-S1765842AbZFOScc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765842AbZFOScc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765259AbZFOScX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:32:23 -0400
Received: from smtp-out.google.com ([216.239.45.13]:35989 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765194AbZFOScW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:32:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=EiawBewrUN+m18RyO4MzLrvF5VcpCV+f0YYY/xi8g2qFk7jIUYtqd0JDGvb/OgIwV
	jyLbf9S9QIltApbau0CdQ==
MIME-Version: 1.0
In-Reply-To: <20090615170103.GE25040@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz>
	 <20090610194852.GA28787@n2100.arm.linux.org.uk>
	 <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com>
	 <20090610213710.GA8472@elf.ucw.cz>
	 <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com>
	 <20090611082532.GE8592@elf.ucw.cz>
	 <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com>
	 <20090612150504.GA15084@elf.ucw.cz>
	 <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com>
	 <20090615170103.GE25040@elf.ucw.cz>
Date: Mon, 15 Jun 2009 11:32:21 -0700
Message-ID: <a55d774e0906151132m5584409epe0b7581fde5ec184@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 10:01 AM, Pavel Machek<pavel@ucw.cz> wrote:
>
> Browsing -msm sources...
>
>        {
>                .name = "flash",
>                .gpio = TROUT_GPIO_FLASH_EN,
>                .max_timeout = 400,
>        },
>
>
> ...in trout... Does dream really support flash?
>
>        {
>                .name = "spotlight",
>                .gpio = TROUT_GPIO_SPOTLIGHT_EN,
>        },
>
> ...what is spotlight? I wish dream had some way to produce light in
> dark...

Earlier revisions had an LED flash for the camera.  This didn't make
it into the final hardware.

Brian
