Return-Path: <linux-kernel-owner+w=401wt.eu-S1760481AbZFKW3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481AbZFKW3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbZFKW3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:29:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755516AbZFKW3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:29:08 -0400
Date: Thu, 11 Jun 2009 15:27:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jiri Slaby <jirislaby@gmail.com>
cc: Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       Ingo Molnar <mingo@elte.hu>, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
In-Reply-To: <4A3182C6.803@gmail.com>
Message-ID: <alpine.LFD.2.01.0906111521210.3535@localhost.localdomain>
References: <20090611165226.GV8633@ZenIV.linux.org.uk> <1244739378.6691.540.camel@laptop> <20090611170015.GA3651@infradead.org> <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com>
 <alpine.LFD.2.01.0906111127520.3573@localhost.localdomain> <20090611202341.GA23590@elte.hu> <1244753357.27363.82.camel@violet> <20090611210810.GA9317@uranus.ravnborg.org> <1244755036.27363.93.camel@violet> <20090611212635.GA9446@uranus.ravnborg.org>
 <4A3182C6.803@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Jun 2009, Jiri Slaby wrote:
> 
> Bah, having 40M .src.rpm for a 5k binary package?

Why do people who don't even know how packaging works bother to even 
participate in the discussion?

Look at how many git binary packages there are some day. For CVS users, 
for SVN people, graphical tools etc. Do you think that each of them has a 
source package?

No.

You can generate multiple binary packages from the same source package 
(trivial example: debug builds etc). But you want to make a point, and 
then YOU USE SOME DAMN IDIOTIC AND IGNORANT argument to do so.

Not smart.

		Linus
