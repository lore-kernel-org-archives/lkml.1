Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbZJESni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbZJESni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 14:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754623AbZJESnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 14:43:37 -0400
Received: from winds.org ([68.75.195.9]:54207 "EHLO winds.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588AbZJESnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 14:43:37 -0400
Date: Mon, 5 Oct 2009 14:42:48 -0400 (EDT)
From: Byron Stanoszek <bstanoszek@comtime.com>
X-X-Sender: gandalf@winds.org
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
In-Reply-To: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com>
Message-ID: <Pine.LNX.4.64.0910051439500.6589@winds.org>
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Oct 2009, Jeff Chua wrote:

> Question is ... is there anyway to increase "low mem" without resorting to 
> migrating to 64bit? (Look... it only has 378MB total low mem vs 850MB on the 
> 4GB system). I've oracle installed on the 64GB system and it keeps getting 
> OOMs!

I have some installations using a 64-bit kernel and a 32-bit OS (including
Oracle). This setup works really well and lets you use all available memory.
You don't even have to upgrade your OS; just swap out the kernel.

  -Byron

