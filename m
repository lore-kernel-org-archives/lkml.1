Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbXCXG5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbXCXG5c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 02:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbXCXG5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 02:57:32 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37439 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbXCXG5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 02:57:31 -0400
Date: Sat, 24 Mar 2007 07:57:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nish Aravamudan <nish.aravamudan@gmail.com>, Ken Chen <kenchen@google.com>,
       Adam Litke <agl@us.ibm.com>, Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] rfc: introduce /dev/hugetlb
Message-ID: <20070324065752.GA13810@uranus.ravnborg.org>
References: <b040c32a0703230144r635d7902g2c36ecd7f412be31@mail.gmail.com> <20070323205810.3860886d.akpm@linux-foundation.org> <29495f1d0703232232o3e436c62lddccc82c4dd17b51@mail.gmail.com> <20070323221225.bdadae16.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323221225.bdadae16.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> But for non-programming reasons, we're just not there yet: people want to
> program direct to the kernel interfaces simply because of the
> distribution/coordination problems with libraries.  It would be nice to fix
> that problem.

What is then needed to get a small subset of user-space in the kernel-development cycle?
Maybe a topic worth to take up at LKS...

The build system is anyway ready but that the smallest issue of all :-(

	Sam
