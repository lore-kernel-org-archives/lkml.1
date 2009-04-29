Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbZD2A0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbZD2A0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 20:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754121AbZD2AZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 20:25:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596AbZD2AZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 20:25:53 -0400
Date: Tue, 28 Apr 2009 17:22:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Paul Mackerras <paulus@samba.org>
cc: Tim Abbott <tabbott@MIT.EDU>, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: Please revert edada399 and 9203fc9c
In-Reply-To: <18934.35969.872225.70725@cargo.ozlabs.ibm.com>
Message-ID: <alpine.LFD.2.00.0904281722180.22156@localhost.localdomain>
References: <18934.35969.872225.70725@cargo.ozlabs.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Apr 2009, Paul Mackerras wrote:
> 
> And they are clearly not fixes for regressions or serious bugs, so why
> are these patches going in after -rc3 anyway?

Yeah, my bad. They looked so obviously trivial, but obviously weren't.

I'm not taking any more of them.

		Linus
