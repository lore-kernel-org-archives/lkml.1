Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbYADSsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbYADSsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 13:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbYADSsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 13:48:13 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3525 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbYADSsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 13:48:12 -0500
Subject: Re: [PATCH x86] [5/16] Replace hard coded reservations in x86-64
	early boot code with dynamic table II
From: Joe Perches <joe@perches.com>
To: Andi Kleen <ak@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080104180650.GA2998@bingen.suse.de>
References: <20080103442.621670000@suse.de> <200801041338.08093.ak@suse.de>
	 <20080104144140.GA4203@elte.hu> <200801041603.58358.ak@suse.de>
	 <20080104175128.GB31382@uranus.ravnborg.org>
	 <20080104180650.GA2998@bingen.suse.de>
Content-Type: text/plain
Date: Fri, 04 Jan 2008 10:47:33 -0800
Message-Id: <1199472453.4888.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-04 at 19:06 +0100, Andi Kleen wrote:
> But the problem with your "rule" is that every of the hundreds
> of Linux kernel contributors will need to do the same. And that's just 
> ineffecient, waste of valuable human work and just doesn't make much sense.
> 
> It certainly won't improve Linux in any way.

What I would prefer is a git option that supports
check-in/outs in a coding style of a user choice.

Commits should be white space ignorant.



