Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbYCUViQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbYCUViQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758011AbYCUViA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:38:00 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46679 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757681AbYCUViA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:38:00 -0400
Date: Fri, 21 Mar 2008 22:37:59 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Madhou <madh2001@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: shell outputs anything typed when the kernel thinks@100%
In-Reply-To: <200803212211.43833.madh2001@gmail.com>
Message-ID: <alpine.LNX.1.00.0803212235130.10642@fbirervta.pbzchgretzou.qr>
References: <200803212211.43833.madh2001@gmail.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 21 2008 22:11, Madhou wrote:
>
> This is a long time annoying misconception i'm reporting here:
>
> When a command is run from a shell and drives the kernel to use 100% of cpu
> for a while, linux lets printing on screen anything that is typed.

[For techies: "But I can type text on the tty even if I run sleep 
1000!"]

Oh yeah wow. It's been like that for what, 15+ years?
This is a shell feature - or bug, depending on how you look at it,
the kernel merely does what the shell did to the tty.
