Return-Path: <linux-kernel-owner+w=401wt.eu-S1763013AbZCaTig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763013AbZCaTig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763367AbZCaTiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:38:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41649 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763361AbZCaTiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:38:12 -0400
Message-ID: <49D27116.8090102@garzik.org>
Date: Tue, 31 Mar 2009 15:37:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Hans-Peter Jansen <hpj@urpla.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <1238168777.5969.18.camel@marge.simson.net> <alpine.LFD.2.00.0903270852070.3994@localhost.localdomain> <200903310000.11522.hpj@urpla.net> <49D142AC.8090701@linux.intel.com>
In-Reply-To: <49D142AC.8090701@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Hans-Peter Jansen wrote:
>> Am Freitag, 27. März 2009 schrieb Linus Torvalds:
>>
>> I always wonder, why Arjan does not intervene for his kerneloops.org 
>> project, since your approach opens a window of uncertainty during the 
>> merge window when simply using git as an efficient fetch tool.
> 
> I would *love* it if Linus would, as first commit mark his tree as "-git0"
> (as per snapshots) or "-rc0". So that I can split the "final" versus
> "merge window" oopses.

Can't you discern that from the v$VERSION tag?  According to your 
definition, -git0 would simply be v2.6.29 commit + 1, correct?

	Jeff




