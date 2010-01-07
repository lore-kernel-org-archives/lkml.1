Return-Path: <linux-kernel-owner+w=401wt.eu-S1751786Ab0AGJwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab0AGJwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482Ab0AGJv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:51:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59451 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab0AGJv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:51:58 -0500
To: Justin Mattock <justinmattock@gmail.com>
Cc: linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] sys_paccept: disable paccept() causes my macbook pro to  have an annoying whining sound
From: Andi Kleen <andi@firstfloor.org>
References: <dd18b0c31001062216m316163f4t992c000eca0f76d@mail.gmail.com>
Date: Thu, 07 Jan 2010 10:51:57 +0100
In-Reply-To: <dd18b0c31001062216m316163f4t992c000eca0f76d@mail.gmail.com> (Justin Mattock's message of "Wed, 6 Jan 2010 22:16:27 -0800")
Message-ID: <873a2ixmwy.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock <justinmattock@gmail.com> writes:

> for a while I've been hearing this odd
> annoying sound coming from my macbook pro
> when the system is idle(no internet use tv/radio/web etc...)
> as soon as I do anything(radio,web) the noise disappears.
>
> here is a  url where they are experiencing the same issue:
> https://help.ubuntu.com/community/MacBook1-1/Hardy
> (down under whining noise);
>
> here is is the result of my bisect:

It's very unlikely that this patch causes power management issues.
I would suggest you double check the bisect.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
