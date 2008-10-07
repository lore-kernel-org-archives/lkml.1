Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYJGXpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYJGXpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbYJGXpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:45:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47561 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYJGXpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:45:45 -0400
Message-ID: <48EBF4A2.4080202@kernel.org>
Date: Tue, 07 Oct 2008 16:45:38 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/3] Provide rdtscll() asm/msr.h for user space
References: <20081007143.793379346@firstfloor.org> <48EBD555.9060104@kernel.org> <20081007231149.GT20740@one.firstfloor.org> <48EBEFCC.4090302@kernel.org> <20081007233709.GW20740@one.firstfloor.org>
In-Reply-To: <20081007233709.GW20740@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> -Andi (who never got this strange meme which is floating around
> in the kernel community for some time that cut'n'pasting interfaces
> into user programs is a sane thing. To me it seems insane.)
> 

Not "cutting and pasting".  Librarizing.

FWIW, I started a git tree for these kinds of stuff at:

	git://git.kernel.org/pub/scm/libs/cpu/libx86/libx86.git

	-hpa
