Return-Path: <linux-kernel-owner+w=401wt.eu-S1762332AbYBEWEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762332AbYBEWEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762030AbYBEWEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:04:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44276 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761973AbYBEWET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:04:19 -0500
Message-ID: <47A8DD49.10209@zytor.com>
Date: Tue, 05 Feb 2008 14:03:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] x86 updates
References: <20080204161219.GA8092@elte.hu> <alpine.LFD.1.00.0802051043550.9374@woody.linux-foundation.org> <20080205192236.GA26426@uranus.ravnborg.org> <20080205210508.GA14708@elte.hu> <20080205211710.GA27589@uranus.ravnborg.org> <20080205215454.GA20724@elte.hu>
In-Reply-To: <20080205215454.GA20724@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
>> I also did a quick skimming of info ld - but no luck.
> 
> Peter pointed me to "info gas", which has a "Sections and Relocation" 
> chapter.
> 

Also see the ".section" directive under pseudo-ops (in the gas doc.)

	-hpa
