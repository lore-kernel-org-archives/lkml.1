Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbXIZXuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbXIZXuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 19:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXIZXtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 19:49:53 -0400
Received: from omr10.networksolutionsemail.com ([205.178.146.60]:47115 "EHLO
	omr10.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146AbXIZXtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 19:49:52 -0400
Message-ID: <46FAF025.90501@nerdgrounds.com>
Date: Wed, 26 Sep 2007 16:49:57 -0700
From: Jonathan Campbell <jon@nerdgrounds.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Patches for tiny 386 kernels, again. Linux kernel 2.6.22.7
References: <46F77A85.6020202@nerdgrounds.com>	<20070924104940.50a52cf3.randy.dunlap@oracle.com>	<46FAA808.90004@nerdgrounds.com> <20070926162059.e6eb5e93.randy.dunlap@oracle.com> <46FAEE97.7090902@nerdgrounds.com> <46FAEF76.9050202@oracle.com>
In-Reply-To: <46FAEF76.9050202@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heh, well of course I vigoursly checked System.map. On my x86 and amd64
systems it removes them all. What a stupid question :-p
> Nope.  I expect(ed) you to do that, i.e., make sure that the patch
> does that the description says that it does.

