Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbZALVa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbZALVa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZALVaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:30:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33429 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbZALVaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:30:12 -0500
Message-ID: <496BB626.9090208@redhat.com>
Date: Mon, 12 Jan 2009 16:29:10 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
References: <20090112153304.GA19995@ioremap.net> <20090112154456.GA27269@redhat.com> <20090112154827.GB20743@ioremap.net> <20090112155108.2646b3ae@lxorguk.ukuu.org.uk> <20090112155211.GA21161@ioremap.net>
In-Reply-To: <20090112155211.GA21161@ioremap.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Mon, Jan 12, 2009 at 03:51:08PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
>>> Well, Kenny has to die, but if we still decide to change the world, here
>>> is the fist step.
>> NAK this entire thing - we have an existing interface that does the job
>> far better.
> 
> Modulo the fact that it does not work for the quickly created processes
> which do not have their oom scores adjusted before the oom.
> 

cgroups solve this problem much more cleanly.

-- Chris
