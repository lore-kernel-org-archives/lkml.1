Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbYGOHaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbYGOHaN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 03:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYGOH37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 03:29:59 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:36143 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbYGOH36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 03:29:58 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PULL] bkl-removal tree
Date: Tue, 15 Jul 2008 09:29:25 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20080714154335.100afd6b@bike.lwn.net>
In-Reply-To: <20080714154335.100afd6b@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807150929.25961.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. Juli 2008 schrieb Jonathan Corbet:
> Hi, Linus,
> 
> Please consider pulling from the bkl-removal tree:
> 
>   git://git.lwn.net/linux-2.6.git bkl-removal

Very nice. 


> Most of these patches have been in linux-next since May with no ill
> effect.  
[...]
>       vmcp: BKL pushdown
[...]
>  drivers/s390/char/vmcp.c                     |    4 ++


Ok. Lets answer this question for anybody :-)
I own this driver and I want to remove the BKL as soon as I am confident its 
ok. Should the followup patch be merged with Jonathans tree or should I sent 
it directly to Andrew or Linus?

Christian
