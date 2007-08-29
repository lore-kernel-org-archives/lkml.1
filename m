Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbXH2VFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbXH2VFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 17:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXH2VFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 17:05:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38027 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbXH2VFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 17:05:23 -0400
Message-ID: <46D5DF7F.9030805@zytor.com>
Date: Wed, 29 Aug 2007 14:05:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Xu Yang <risingsunxy@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: from which address does the kernel load initrd?
References: <ab40e9c0708291348u3c4ee095r20cd20dd090c23aa@mail.gmail.com>
In-Reply-To: <ab40e9c0708291348u3c4ee095r20cd20dd090c23aa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xu Yang wrote:
> does anyone know from which address does the kernel load the initrd? I
> mean the default value?
> 
> I want to boot the filesystem using a ramdisk. but the I don't know
> where to put it in my ram? as I don't have flash , I can only load the
> ramdisk into the ram.
> 
> and which boot option should I use?

See Documentation/i386/boot.txt

	-hpa

