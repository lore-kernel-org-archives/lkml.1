Return-Path: <linux-kernel-owner+w=401wt.eu-S1765362AbXJZUnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765362AbXJZUnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbXJZUnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:43:04 -0400
Received: from mx1.suse.de ([195.135.220.2]:53095 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbXJZUnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:43:02 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [AppArmor 00/45] AppArmor security module overview
Date: Fri, 26 Oct 2007 22:44:56 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
References: <20071026064024.243943043@suse.de> <20071026073721.618b4778@laptopd505.fenrus.org>
In-Reply-To: <20071026073721.618b4778@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710262244.57147.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007 16:37, Arjan van de Ven wrote:
> In addition, I'd like to ask you to put a file in Documentation/
> somewhere that describes what AppArmor is intended security protection
> is (it's different from SELinux for sure for example); by having such a
> document for each LSM user, end users and distros can make a more
> informed decision which module suits their requirements... and it also 
> makes it possible to look at the implementation to see if it has gaps
> to the intent, without getting into a pissing contest about which
> security model is better; but unless the security goals are explicitly
> described that's a trap that will keep coming back... so please spend
> some time on getting a good description going here..

Hmm, I agree that it makes sense to give a short overview of each LSM. A 
description of the AppArmor model and implementation can be found in the 
directory that John referred to actually. I'm unsure how much of that makes 
sense under Documentation/ -- what do you think? 

 http://forgeftp.novell.com/apparmor/LKML_Submission-Oct-07/techdoc.pdf

I guess actual end user information doesn't belong in the kernel sources; that 
really seems wrong.

Thanks,
Andreas
