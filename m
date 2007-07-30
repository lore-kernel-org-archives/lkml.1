Return-Path: <linux-kernel-owner+w=401wt.eu-S965778AbXG3AIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965778AbXG3AIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 20:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763826AbXG3AIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 20:08:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39155 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764031AbXG3AIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 20:08:37 -0400
Date: Sun, 29 Jul 2007 17:08:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] Remove fs.h from mm.h
In-Reply-To: <20070729223613.GA5916@martell.zuzino.mipt.ru>
Message-ID: <alpine.LFD.0.999.0707291706490.3442@woody.linux-foundation.org>
References: <20070729223613.GA5916@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jul 2007, Alexey Dobriyan wrote:
> 
> Cross-compile tested without regressions on my two usual configs and (sigh):
> 
> alpha              arm-mx1ads        mips-bigsur          powerpc-ebony
..

Heh. 

Kudos for going above and beyond.

	"But where is blackfin and frv?"

Thanks,

		Linus
