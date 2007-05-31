Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbXEaDzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbXEaDzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 23:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756496AbXEaDzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 23:55:48 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755601AbXEaDzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 23:55:48 -0400
Date: Wed, 30 May 2007 20:55:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bryan Wu <bryan.wu@analog.com>
cc: akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] [RAMFS NOMMU]: a bug in ramfs_nommu_resize function,
 passing old size to vmtruncate
In-Reply-To: <1180582528.10836.6.camel@roc-laptop>
Message-ID: <alpine.LFD.0.98.0705302054380.26602@woody.linux-foundation.org>
References: <1180582315.10836.2.camel@roc-laptop>
 <1180582528.10836.6.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 May 2007, Bryan Wu wrote:
> 
> Sorry for sending this email several times , my git-send-email got some
> problem.

The patch was whitespace-damaged (tabs had been turned into spaces).

But I fixed it up and applied it.

		Linus
