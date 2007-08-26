Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbXHZECe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbXHZECe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 00:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbXHZECZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 00:02:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55768 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbXHZECY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 00:02:24 -0400
Date: Sun, 26 Aug 2007 09:45:04 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-alpha@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Oliver Falk <oliver@linux-kernel.at>
Subject: Re: [4/4] 2.6.23-rc3: known regressions v3
In-Reply-To: <46CF17A0.2060503@googlemail.com>
Message-ID: <alpine.LFD.0.999.0708260943400.26486@enigma.security.iitk.ac.in>
References: <46CF0DEF.5040107@googlemail.com>
 <46CF17A0.2060503@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 24 Aug 2007, Michal Piotrowski wrote:
> 
> Alpha
> 
> Subject         : -Werror compilation problem - make[1]: *** [arch/alpha/kernel/sys_titan.o] Error 1
> References      : http://lkml.org/lkml/2007/8/6/137
> Last known good : ?
> Submitter       : Oliver Falk <oliver@linux-kernel.at>
> Caused-By       : ?
> Handled-By      : ?
> Status          : unknown

This was fixed by commit f6901e639800e745457b1dcd99c52647981438d7.
