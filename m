Return-Path: <linux-kernel-owner+w=401wt.eu-S1765539AbYBODZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765539AbYBODZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 22:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757082AbYBODZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 22:25:22 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:60418 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbYBODZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 22:25:21 -0500
Message-ID: <47B5068A.60808@keyaccess.nl>
Date: Fri, 15 Feb 2008 04:27:06 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Arjan van de Ven <arjan@linux.intel.com>, Bill Davidsen <davidsen@tmr.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jiri Slaby <jirislaby@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
Subject: Re: Feature Removals for 2.6.25
References: <1201829922.23523.68.camel@brick>	<47B3AC24.5050605@tmr.com> <20080213185502.0005dd4d@extreme> <47B48564.1010709@tmr.com> <47B4876B.6020100@linux.intel.com> <47B4CCBC.6050208@davidnewall.com>
In-Reply-To: <47B4CCBC.6050208@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-02-08 00:20, David Newall wrote:

> Arjan van de Ven wrote:
>> Bill Davidsen wrote:
>>> Note that because the hardware is old, it's highly likely that most
>>> of it will be retired before that sk98lin driver needs a change. I
>>> can't see anyone using sk98lin on a new system, so it would be less
>>> contentious to let the hardware (or users) die of natural causes if
>>> you can.
>>>
>> the problem is that the new one DOES NOT GET FIXED.
>> THAT is a huge problem; it means we have a buggy driver...
> 
> If the old one works and the new one is buggy, it begs the question of
> why anybody bothered writing a new one in the first place.  "If it ain't
> broke, don't fix it," might have been good advice to follow.

Not generally. A usual scenario is the new driver working on newer hardware 
versions than the old one supports but not necessarily on all the old ones 
the previous driver supported if only due to to availability of the older 
hardware for testing.

Rene.
