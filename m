Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbZJFRk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbZJFRk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757701AbZJFRkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:40:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757298AbZJFRky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:40:54 -0400
Date: Tue, 6 Oct 2009 10:40:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: kyle@mcmartin.ca
cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: [git patches] parisc for 2.6.32
In-Reply-To: <20091006172602.GA1924@hera.kernel.org>
Message-ID: <alpine.LFD.2.01.0910061035050.3432@localhost.localdomain>
References: <20091006172602.GA1924@hera.kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, Kyle McMartin wrote:
<
> Mostly fixes, except for the tracehook stuff...

I don't see how this can be fixes, since I can't recall any parisc pulls 
during the merge window.

Yes, there have been parisc changes, but they've all come in through 
commits that either were global and people also fixed up parisc while at 
it (eg things like "fcntl: add F_[SG]ETOWN_EX"), or they have been build 
cleanups where you were cc'd but apparently never even bothered to ack the 
change.

So now you come in after the merge window has been closed for over a week, 
and want to do a parisc merge?

Tell me why I should take this. Tell me why I shouldn't just wait until 
the next merge window (or rather "_you_ should have waited").

I've now had two pull requests just today that made me go "I don't really 
see why I should pull this after -rc3 is out".

			Linus
