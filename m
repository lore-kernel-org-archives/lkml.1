Return-Path: <linux-kernel-owner+w=401wt.eu-S932826AbZJFOgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826AbZJFOgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932818AbZJFOgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:36:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932813AbZJFOgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:36:39 -0400
Date: Tue, 6 Oct 2009 07:35:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Valdis.Kletnieks@vt.edu, Tomasz Chmielewski <mangoo@wpkg.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Byron Stanoszek <bstanoszek@comtime.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
In-Reply-To: <b6a2187b0910052312o662642b2teded3d19548b9151@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0910060731190.3432@localhost.localdomain>
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com>  <alpine.LFD.2.01.0910051110200.3432@localhost.localdomain>  <b6a2187b0910051715y4ee63503y148ba2d7e24cad8e@mail.gmail.com>  <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain>
 <b6a2187b0910052312o662642b2teded3d19548b9151@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, Jeff Chua wrote:
> 
> First, have to compile gcc so that it can compile 64 bit kernel. That's a
> tough one!

It's supposed to be easier these days, but I guess distros don't compile 
in support for 64-bit mode by default. Just using another machine may be 
the simplest approach, if you have any 64-bit distro around.

		Linus
