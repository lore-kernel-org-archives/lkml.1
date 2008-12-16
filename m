Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbYLPPE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbYLPPE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbYLPPEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:04:35 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:51161 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbYLPPEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:04:33 -0500
Date: Tue, 16 Dec 2008 15:04:31 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Aristeu Rozanski <aris@redhat.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/2] IOAPIC NMI watchdog fixes
In-Reply-To: <20081215112315.GA51028@redhat.com>
Message-ID: <alpine.LFD.1.10.0812161459590.12979@ftp.linux-mips.org>
References: <20081027164233.132189000@napanee.usersys.redhat.com> <alpine.LFD.1.10.0810271651520.18692@ftp.linux-mips.org> <20081215112315.GA51028@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2008, Aristeu Rozanski wrote:

> >  Thanks, I'll see if I can find some time soon to give them a hit -- I've 
> > got a serial console on my laptop now, :) so any odd boot-time tests will 
> > be easier for me.  These would be best tested with Ingo's APIC tree, a 
> > current snapshot of which I may not have handy.  Ping me if I don't 
> > respond within a few days.
> ping :)

 Pong.  Recent weeks have been rather hectic for me.  I'll see if I can 
find an hour or so over the Christmas period.  The thing is to test 2/2 
properly I need to tweak the sources to pretend the IRQ routing tables on 
my system are different than they really are and it takes a short while.  
We shall see.  Thanks for your patience. :)

  Maciej
