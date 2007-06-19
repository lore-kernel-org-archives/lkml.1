Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbXFSVh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbXFSVh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 17:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXFSVhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 17:37:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbXFSVht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 17:37:49 -0400
Message-ID: <46784CA9.4060609@redhat.com>
Date: Tue, 19 Jun 2007 17:37:45 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Joshua David Williams <yurimxpxman.lkml@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: GPLv3 dispute solution - new open source license?
References: <200706181725.01584.yurimxpxman@gmail.com>
In-Reply-To: <200706181725.01584.yurimxpxman@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joshua David Williams wrote:
> I've been keeping tabs on the GPLv3 dispute for quite some time. It seems to 
> me that the best solution would be for us to write our own open source 
> license - one that would be written specifically to uphold the ten rights in 
> the open source definition.

Your solution for license fragmentation is more license fragmentation?  GPLv2 is 
a damn good license.  If we're going to undertake the arduous task of 
relicensing the kernel, it had better be worth the payoff.  GPLv3 is being 
considered because:

1)	A lot of the GPLv2 code in the kernel was explicitly authorized by the 
contributor to be distributed under future versions of the GPL published by the 
FSF.  This means we only have to go through the headache of getting 
authorization to relicense for a much smaller code base than the whole kernel.

2)	The influence of the FSF and ubiquity of GNU tools means that a large chunk 
of code is going to be released under GPLv3.  This cannot be said for your license.

> I'm not a lawyer

GPLv3 was written by a whole bunch of lawyers, all of them trained and 
experienced to consider the extended ramifications of the precise wording of the 
license in numerous jurisdictions worldwide.  The current draft is already a 
compromise between GPLv2 and earlier GPLv3 drafts.  It's quite possible that the 
kernel will never relicense, and that's okay, because we already have a good 
license, the GPLv2, which was also written by a lawyer.

	-- Chris
