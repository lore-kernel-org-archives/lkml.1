Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbYGYSOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbYGYSOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbYGYSO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:14:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151AbYGYSO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:14:29 -0400
Date: Fri, 25 Jul 2008 11:10:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Please pull from powerpc.git merge branch
In-Reply-To: <1216973590.11188.99.camel@pasglop>
Message-ID: <alpine.LFD.1.10.0807251108320.5249@nehalem.linux-foundation.org>
References: <1216973590.11188.99.camel@pasglop>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 Jul 2008, Benjamin Herrenschmidt wrote:
> 
> ﻿git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Ok, I got a conflict in arch/powerpc/platforms/52xx/Kconfig, you should 
check that I fixed it up right and send me follow-up patches if required.

		Linus
