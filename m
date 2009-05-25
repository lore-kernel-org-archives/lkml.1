Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbZEYWwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbZEYWwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZEYWw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:52:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825AbZEYWwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:52:25 -0400
Date: Mon, 25 May 2009 15:51:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Thomas Gleixner <tglx@linutronix.de> Suresh Siddha" 
	<suresh.siddha@intel.com>,
       Tejun Heo <tj@kernel.org>,
       Venkatesh Pallapadi <venkatesh.pallapadi@intel.com>,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [GIT PULL] x86 fixes for 2.6.30-rc8
In-Reply-To: <alpine.LFD.2.01.0905251543570.3435@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0905251550320.3435@localhost.localdomain>
References: <200905252003.n4PK3sFi014919@voreg.hos.anvin.org> <alpine.LFD.2.01.0905251543570.3435@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 May 2009, Linus Torvalds wrote:
> 
> Now you made it do two different "on_each_cpu" things. Maybe it doesn't 
> matter, but it just seems wrong.

Btw, I pulled, I just wanted to note that I don't think this was done 
optimally/cleanly.

		Linus
