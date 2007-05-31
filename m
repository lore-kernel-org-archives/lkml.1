Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbXEaETZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbXEaETZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbXEaETR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:19:17 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661AbXEaETR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:19:17 -0400
Date: Wed, 30 May 2007 21:18:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bryan.wu@analog.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] [RAMFS NOMMU]: a bug in ramfs_nommu_resize function,
 passing old size to vmtruncate
Message-Id: <20070530211859.355172e2.akpm@linux-foundation.org>
In-Reply-To: <1180584202.6363.6.camel@roc-laptop>
References: <1180582315.10836.2.camel@roc-laptop>
	<1180582528.10836.6.camel@roc-laptop>
	<alpine.LFD.0.98.0705302054380.26602@woody.linux-foundation.org>
	<1180584202.6363.6.camel@roc-laptop>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 12:03:22 +0800 Bryan Wu <bryan.wu@analog.com> wrote:

> W: unable to extract a valid address from: torvalds@linux-foundation.org akpm@linux-fundation.org linux-kernel@vger.kernel.org

Maybe it didn't like the "fundation" typo.
