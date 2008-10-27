Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbYJ0XIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbYJ0XIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYJ0XI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:08:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259AbYJ0XI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:08:28 -0400
Date: Mon, 27 Oct 2008 16:08:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: remove unused variable
In-Reply-To: <200810272303.m9RN3Dw8032499@agluck-lia64.sc.intel.com>
Message-ID: <alpine.LFD.2.00.0810271607220.3386@nehalem.linux-foundation.org>
References: <200810272303.m9RN3Dw8032499@agluck-lia64.sc.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 27 Oct 2008, Luck, Tony wrote:
> 
> Linus,  I guess you don't build with CONFIG_CGROUPS=y or you'd
> have fixed this, or taken one of the patches that fix it. I'm
> tired of seeing the warning in my build log :-)

Hmm.. Committed on Sunday. Should hav been in -rc2 already, no?

		Linus
