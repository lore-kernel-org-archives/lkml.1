Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbXGGVTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbXGGVTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 17:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbXGGVTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 17:19:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36925 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751817AbXGGVTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 17:19:10 -0400
Date: Sat, 7 Jul 2007 14:18:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Patrick Caulfield <pcaulfie@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>, teigland@redhat.com,
       cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22 regression fix] DLM must depend on SYSFS
In-Reply-To: <20070707211110.GL3492@stusta.de>
Message-ID: <alpine.LFD.0.999.0707071417500.31544@woody.linux-foundation.org>
References: <20070707041402.GE3492@stusta.de>
 <alpine.LFD.0.999.0707071350380.31544@woody.linux-foundation.org>
 <20070707211110.GL3492@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 7 Jul 2007, Adrian Bunk wrote:
> 
> Usually I'm for the usage of "select" in such cases, but since this is 
> with CONFIG_EMBEDDED=y where users can be expected to know better what 
> they are doing I'd say a "depends on" is fine.

Fair enough.

		Linus
