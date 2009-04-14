Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbZDNRjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbZDNRjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbZDNRiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:38:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613AbZDNRit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:38:49 -0400
Date: Tue, 14 Apr 2009 10:32:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       serue@us.ibm.com, dave@linux.vnet.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
In-Reply-To: <49E4C5BD.1040405@oracle.com>
Message-ID: <alpine.LFD.2.00.0904141031320.18124@localhost.localdomain>
References: <20090410023207.GA27788@x200.localdomain> <alpine.LFD.2.00.0904100758410.4583@localhost.localdomain> <20090413073925.GB7085@x200.localdomain> <alpine.LFD.2.00.0904131137520.26713@localhost.localdomain> <20090414122906.GA20201@x200.localdomain>
 <alpine.LFD.2.00.0904141006170.18124@localhost.localdomain> <49E4C5BD.1040405@oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Apr 2009, Randy Dunlap wrote:
> > 
> > So let's call it "checkpoint" and "restore". Ok?
> 
> restart ?

Even better (and proving my point that trying to use contractions like 
"rst" can be misleading, although I agree with Ingo that the most common 
mistake would be "reset")

			Linus
