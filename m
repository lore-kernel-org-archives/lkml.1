Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbYGZAgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbYGZAgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 20:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYGZAgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 20:36:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbYGZAgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 20:36:17 -0400
Date: Fri, 25 Jul 2008 17:32:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nishanth Aravamudan <nacc@us.ibm.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       mingo@elte.hu, randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] hugetlb: fix CONFIG_SYSCTL=n build
In-Reply-To: <20080725203351.GA18407@us.ibm.com>
Message-ID: <alpine.LFD.1.10.0807251732160.4188@nehalem.linux-foundation.org>
References: <20080721.233512.128618365.anemo@mba.ocn.ne.jp> <20080721191519.GA15843@elte.hu> <20080721214258.787a67ca@lxorguk.ukuu.org.uk> <20080722072334.GA25241@elte.hu> <48865899.3030209@garzik.org> <20080723104520.GA20672@elte.hu> <20080724052603.GA8744@elte.hu>
 <20080725180935.5bd02bf5@lxorguk.ukuu.org.uk> <20080725203351.GA18407@us.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 Jul 2008, Nishanth Aravamudan wrote:
>
> [resending with Linus' address fixed]

Hmm, this doesn't apply for me any more. Can you check the current -git 
tree?

		Linus
