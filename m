Return-Path: <linux-kernel-owner+w=401wt.eu-S934188AbYD3W1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934188AbYD3W1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762696AbYD3W1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:27:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59889 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762604AbYD3W1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:27:33 -0400
Message-ID: <4818EB1E.3090700@zytor.com>
Date: Wed, 30 Apr 2008 14:56:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: dmitri.vorobiev@gmail.com, mingo@elte.hu, tglx@linutronix.de,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove NexGen support (fwd)
References: <20080429081729.GA3921@ucw.cz> <20080430213457.GD18536@elf.ucw.cz> <4818E777.2070702@zytor.com> <20080430215133.GE18536@elf.ucw.cz>
In-Reply-To: <20080430215133.GE18536@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> http://www.cpu-info.com/index2.php?mainid=Nx586&page=7
> 
> I do not know how many were really shipped, and yes, they seem to be
> pretty uncommon, but it sounds like more than samples. Actually, some
> seem to be for sale on ebay ;-).
> 

Cool.  If someone is willing to pick one up and maintain this fairly 
trivial amount of code we can resurrect it; given that the code had been 
broken for several releases seem to indicate noone really cares.

(Also note that the removal will not prevent the kernel from actually 
running on these chips; in fact, it might actually make them work.)

	-hpa
