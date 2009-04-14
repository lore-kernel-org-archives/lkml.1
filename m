Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbZDNRPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbZDNRPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZDNRPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:15:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132AbZDNRPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:15:34 -0400
Date: Tue, 14 Apr 2009 10:09:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
In-Reply-To: <20090414122906.GA20201@x200.localdomain>
Message-ID: <alpine.LFD.2.00.0904141006170.18124@localhost.localdomain>
References: <20090410023207.GA27788@x200.localdomain> <alpine.LFD.2.00.0904100758410.4583@localhost.localdomain> <20090413073925.GB7085@x200.localdomain> <alpine.LFD.2.00.0904131137520.26713@localhost.localdomain> <20090414122906.GA20201@x200.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Apr 2009, Alexey Dobriyan wrote:
> > 
> > We're not merging OpenVZ code _either_.
> 
> This is to give example of other prefixes: cpt_ and rst_
> Are they fine?

Do you secretly work for IBM?

IBM has a well-known disdain for vowels, and basically refuses to use them 
for mnemonics (they were called on this, and did "eieio" as an instruction 
just to try to make up for it).

But I'm from Finland. In Finnish, about 75% of all letters are vowels. I 
find this dis-emvoweling to be stupid and impractical. Without vowels, you 
can't tell Finnish words apart (admittedly, _with_ vowels, you generally 
cannot pronounce them, so to a non-Finn it doesn't much matter).

My point is, let's go for a happy medium - LEAVE THE F*CKING VOWELS IN 
PLACE ALREADY.

So let's call it "checkpoint" and "restore". Ok?

		Linus
