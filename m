Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbZC1VM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbZC1VM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 17:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759231AbZC1VMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 17:12:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759229AbZC1VMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 17:12:07 -0400
Date: Sat, 28 Mar 2009 14:09:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>, Shaohua Li <shaohua.li@intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] async / fast boot patches
In-Reply-To: <20090328131315.090fde9d@infradead.org>
Message-ID: <alpine.LFD.2.00.0903281408110.3994@localhost.localdomain>
References: <20090328131315.090fde9d@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Mar 2009, Arjan van de Ven wrote:
> 
> Li, Shaohua (1):
>       fastboot: remove duplicate unpack_to_rootfs()

This one clashed with the compression changes - but I think I resolved it 
ok. But somebody who actually uses initramfs should definitely 
double-check my merge.

		Linus
