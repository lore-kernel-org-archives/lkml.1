Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbXCXHpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbXCXHpa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 03:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932368AbXCXHpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 03:45:30 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59280 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309AbXCXHp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 03:45:29 -0400
Date: Fri, 23 Mar 2007 23:41:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Nish Aravamudan <nish.aravamudan@gmail.com>, Ken Chen <kenchen@google.com>,
       Adam Litke <agl@us.ibm.com>, Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] rfc: introduce /dev/hugetlb
Message-Id: <20070323234156.72b955e9.akpm@linux-foundation.org>
In-Reply-To: <20070324065752.GA13810@uranus.ravnborg.org>
References: <b040c32a0703230144r635d7902g2c36ecd7f412be31@mail.gmail.com>
	<20070323205810.3860886d.akpm@linux-foundation.org>
	<29495f1d0703232232o3e436c62lddccc82c4dd17b51@mail.gmail.com>
	<20070323221225.bdadae16.akpm@linux-foundation.org>
	<20070324065752.GA13810@uranus.ravnborg.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2007 07:57:52 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:

> > 
> > But for non-programming reasons, we're just not there yet: people want to
> > program direct to the kernel interfaces simply because of the
> > distribution/coordination problems with libraries.  It would be nice to fix
> > that problem.
> 
> What is then needed to get a small subset of user-space in the kernel-development cycle?

Someone to lead the work, mainly.  It would be a large effort, a lot of
time and email traffic.

> Maybe a topic worth to take up at LKS...

Well, perhaps.  But unless someone with suitable experience has enough time
and energy to spare to make it happen, it won't be happening.

