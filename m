Return-Path: <linux-kernel-owner+w=401wt.eu-S933377AbZJFUyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbZJFUyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933327AbZJFUyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:54:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:58356 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933324AbZJFUyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:54:18 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX18mT/xwMbomNxgtMPaMeGy4msoe5DwL84N8aogUvX
	jEa0w5BuqIfOpp
Message-ID: <4ACBAE49.9020903@gmx.de>
Date: Tue, 06 Oct 2009 22:53:29 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org
Subject: Re: [git patches] parisc for 2.6.32
References: <20091006172602.GA1924@hera.kernel.org> <alpine.LFD.2.01.0910061035050.3432@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910061035050.3432@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 10/06/2009 07:40 PM, Linus Torvalds wrote:
> On Tue, 6 Oct 2009, Kyle McMartin wrote:
>> Mostly fixes, except for the tracehook stuff...
>
> I don't see how this can be fixes, since I can't recall any parisc pulls
> during the merge window.

Yes, sadly it was not in time.
And of course it's no excuse, that you didn't received a real pull-request,
even after Kyle asked for feedback for his tree with his mail on LKML and
parisc-list on 2009-09-28:
http://www.pubbs.net/kernel/200909/123965/

> So now you come in after the merge window has been closed for over a week,
> and want to do a parisc merge?
>
> Tell me why I should take this. Tell me why I shouldn't just wait until
> the next merge window (or rather "_you_ should have waited").

This patch really only touches parisc-specific files and it includes
important fixes without which the parisc kernel won't even compile and link.
So, it would help us parisc-porters a lot if you could do an exception and
still pull from Kyle's tree, even after this merge window has been closed.
At least, it would make me personally very happy...

Helge
