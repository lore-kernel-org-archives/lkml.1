Return-Path: <linux-kernel-owner+w=401wt.eu-S934013AbYBNVJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013AbYBNVJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758393AbYBNVJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:09:25 -0500
Received: from vena.lwn.net ([206.168.112.25]:52104 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756783AbYBNVJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:09:24 -0500
To: "Oliver Pinter" <oliver.pntr@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] Avoid buffer overflows in get_user_pages() 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Thu, 14 Feb 2008 17:45:51 +0100."
             <6101e8c40802140845h563f7ceeseea824dee4a1ab77@mail.gmail.com> 
Date: Thu, 14 Feb 2008 14:09:22 -0700
Message-ID: <576.1203023362@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Pinter <oliver.pntr@gmail.com> wrote:

> for stable (.22 .23 .24) ?
> 
> git id in mainline: 900cf086fd2fbad07f72f4575449e0d0958f860f

I sent it to the stable folks a couple days ago.

Thanks,

jon

Jonathan Corbet / LWN.net / corbet@lwn.net
