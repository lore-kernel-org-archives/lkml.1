Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbXEaCWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbXEaCWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 22:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbXEaCW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 22:22:27 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480AbXEaCW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 22:22:26 -0400
Date: Wed, 30 May 2007 19:22:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [2/4] 2.6.22-rc3: known regressions
In-Reply-To: <465C22F4.8080505@googlemail.com>
Message-ID: <alpine.LFD.0.98.0705301918450.26602@woody.linux-foundation.org>
References: <465C188F.9000900@googlemail.com>
 <465C22F4.8080505@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 May 2007, Michal Piotrowski wrote:
> 
> Subject    : Oops on 2.6.22-rc2 when unloading the cciss driver
> References : http://lkml.org/lkml/2007/5/24/172
> Submitter  : Mike Miller (OS Dev) <mikem@beardog.cca.cpqcorp.net>
> Status     : Unknown

I thought this one should be fixed by commit e9ca75b53. Not so?

Mike?

			Linus
